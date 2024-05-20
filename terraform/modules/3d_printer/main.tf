module "ceph_volume" {
  source = "../ceph_volume"

  name            = "${var.printer_name}_config"
  capacity_max    = "10G"
  capacity_min    = "1G"
  username        = var.ceph_user_id
  user_key        = var.ceph_user_key
  cluster_id      = var.ceph_cluster_id
}

resource "consul_key_prefix" "printer_cfg" {
  path_prefix = "apps/3d_printers/${var.printer_name}/"

  subkeys = var.printer_configs
}

resource "nomad_job" "job" {
  jobspec = templatefile(
    "${path.module}/printer_jobs.nomad.hcl",
    {
      printer_name      = var.printer_name
      printer_data_path = "/var/printer_data"
      config_path       = "/var/printer_data/config"
      csi_volume_name   = module.ceph_volume.volume_name

      config_key_prefix = consul_key_prefix.printer_cfg.path_prefix
      machine_configs   = var.printer_configs

      klipper_img_version   = var.klipper_img_version
      moonraker_img_version = var.moonraker_img_version
    }
  )
}
