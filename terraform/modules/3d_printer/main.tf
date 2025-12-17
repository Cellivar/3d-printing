module "ceph_volume" {
  source = "../ceph_volume"

  name         = "${var.printer_name}_config"
  capacity_max = "10G"
  capacity_min = "1G"
  username     = var.ceph_user_id
  user_key     = var.ceph_user_key
  cluster_id   = var.ceph_cluster_id
}

locals {
  consul_template_key = "apps/3d_printers/${var.printer_name}_consul_template"
  consul_template_printer_data_mount = "/var/printer_data"

  # To populate the consul keys for configs we combine all of the configs
  # and the conditional configs. We project the list of objects into a key/val
  # map, so they can be identified uniquely.
  # First pull the options objects out into their own list
  conditional_options = flatten([
    for c in var.printer_conditional_configs : c.options
  ])
  # Then into a key/value pair
  consul_key_map = merge(var.printer_configs, {
    for c in local.conditional_options : c.key => c.content
  })

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
  static_consul_configs = <<-EOF
    %{for key, val in var.printer_configs}
    template {
      # Drop files into the config directory, setting permissions correctly.
      destination = "${local.consul_template_printer_data_mount}/config/${key}"
      perms       = "0666"
      uid         = 1000
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

  # These configs work similarly, with the added benefit of conditional contents.
  # This allows for more rapid config changes by responding to, say, a change
  # in a consul key/value value or an environment variable. Instead of running
  # the full terraform workflow, we can do things like switch between connected
  # toolheads by changing a consul kv value and restarting Moonraker.
  # TODO: Figure out how to script that to be even faster and easier, maybe even
  # with a Moonraker component or something..
  conditional_consul_configs = <<-EOF
    %{for conf in var.printer_conditional_configs}
    template {
      # Drop files into the config directory, setting permissions correctly.
      destination = "${local.consul_template_printer_data_mount}/config/${conf.out_file}"
      perms       = "0666"
      uid         = 1000
      gid         = 1000

      # Jinja syntax collides, override to something silly instead
      left_delimiter  = "{!!{"
      right_delimiter = "}!!}"
      contents    = <<EOH
    %{for opt in conf.options}
    {!!{ if (${opt.condition}) }!!}
    {!!{ key "${consul_key_prefix.printer_cfg.path_prefix}${opt.key}" }!!}
    {!!{ end }!!}
    %{endfor}
    EOH
    }
    %{endfor}
    EOF

  # Finally, moosh them all together into one config
  consul_config_template = <<-EOF
    ${local.consul_config_preamble}
    ${local.static_consul_configs}
    ${local.conditional_consul_configs}
    EOF
}

resource "consul_keys" "consul_template_config" {
  key {
    path  = local.consul_template_key
    value = local.consul_config_template
  }
}

resource "consul_key_prefix" "printer_cfg" {
  path_prefix = "apps/3d_printers/${var.printer_name}/"

  subkeys = local.consul_key_map
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
