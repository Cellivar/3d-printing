module "ceph_volume" {
  source = "../ceph_volume"

  name         = "${var.printer_name}_config"
  capacity_max = "10G"
  capacity_min = "1G"
  username     = var.ceph_user_id
  user_key     = var.ceph_user_key
  cluster_id   = var.ceph_cluster_id
}

resource "consul_key_prefix" "printer_cfg" {
  path_prefix = "apps/3d_printers/${var.printer_name}/"

  subkeys = var.printer_configs
}

locals {
  consul_template_key = "apps/3d_printers/${var.printer_name}_consul_template"
  consul_template_printer_data_mount = "/var/printer_data"

  consul_config_preamble = <<-EOF
    # Configuration file for consul-template to populate config files in the mounted
    # printer_data directory. This prevents needing to reboot when modifying basic
    # configs, though it very often requires a restart of klipper via moonraker.

    # Enable consul, talking to the localhost agent with no auth
    consul {}
    log_level = "info"


    EOF

  # Here we do something a little sneaky. Normally consul-template can't handle
  # nested templates. We can work around this because Nomad itself can do a pass
  # then the running consul-template job can do a second pass. Here we generate
  # the list of all of the template blocks that consul-template needs, then we
  # store that list as a value in consul k/v. The nomad job renders the full
  # config, then the running jobs renders out the individual configs! Single
  # depth nested templates, without cheating too much.
  consul_config_template = <<-EOF
    ${local.consul_config_preamble}
    %{for key, val in var.printer_configs}
    template {
      # Drop files into the config directory, setting permissions correctly.
      destination = "${local.consul_template_printer_data_mount}/config/${key}"
      perms       = "0666"
      gid         = 1000

      # Jinja syntax collides, override to something silly instead
      left_delimiter  = "{!!{"
      right_delimiter = "}!!}"
      contents    = <<EOH
    {!!{ key "${consul_key_prefix.printer_cfg.path_prefix}${key}" }!!}
    EOH
    }
    %{endfor}
    EOF
}

resource "consul_keys" "consul_template_config" {
  key {
    path  = local.consul_template_key
    value = local.consul_config_template
  }
}

resource "nomad_job" "job" {
  jobspec = templatefile(
    "${path.module}/printer_jobs.nomad.hcl",
    {
      printer_name          = var.printer_name
      csi_volume_name       = module.ceph_volume.volume_name

      klipper_img_version   = var.klipper_img_version
      moonraker_img_version = var.moonraker_img_version

      consul_template_mount = local.consul_template_printer_data_mount
      consul_template_key   = local.consul_template_key
    }
  )
}
