locals {
  tmpldir = "${path.module}/../configs/klipper"

  klipper_img_version   = "v0.12.0-125-gbfb71bc2"
  moonraker_img_version = "v0.8.0-324-ga3e4dac"
  fluidd_img_version    = "v1.28.1"
  spoolman_img_version  = "0.18"
  manyfold_img_version  = "0.67.0"

  # Config files expected to be on every printer.
  common_configs = {
    "main.cfg"               = file("${local.tmpldir}/common/main.cfg")
    "common/fluidd.cfg"      = file("${local.tmpldir}/common/fluidd.cfg")
    "common/timelapse.cfg"   = file("${local.tmpldir}/common/timelapse.cfg")
    "macros/util_macros.cfg" = file("${local.tmpldir}/common/util_macros.cfg")
  }
}

data "vault_kv_secret_v2" "ceph" {
  mount = "secret"
  name  = "ceph/config"
}

module "printer_bildhauerkabine" {
  source = "./modules/3d_printer"

  ceph_user_id    = data.vault_kv_secret_v2.ceph.data.user_id
  ceph_user_key   = data.vault_kv_secret_v2.ceph.data.user_key
  ceph_cluster_id = data.vault_kv_secret_v2.ceph.data.cluster_id

  printer_name          = "bildhauerkabine"
  klipper_img_version   = local.klipper_img_version
  moonraker_img_version = local.moonraker_img_version

  # Config files specific to this printer, merged with the common list.
  printer_configs = merge(local.common_configs, {
    "main_printer.cfg"          = file("${local.tmpldir}/bildhauerkabine/main_printer.cfg")
    "macros/macros.cfg"         = file("${local.tmpldir}/bildhauerkabine/macros.cfg")
    "pins/octopus_1_1_pins.cfg" = file("${local.tmpldir}/pins/octopus_1_1_pins.cfg")
    "pins/mini12864.cfg"        = file("${local.tmpldir}/pins/mini12864.cfg")
    "pins/ebb36.cfg" = templatefile("${local.tmpldir}/pins/ebb36.cfg", {
      mcu_name    = "ebb36"
      canbus_uuid = "ad5151bfad1d"
    })
    "moonraker.conf" = templatefile("${local.tmpldir}/common/moonraker.conf", {
      power_relay_gpio = "!gpio18"
    })
    "common/bttsfs2.cfg" = templatefile("${local.tmpldir}/common/bttsfs2.cfg", {
      motion_pin       = "SENSOR6",
      switch_pin       = "SENSOR5",
      sensor_name      = "bttsfs2",
      related_extruder = "extruder"
    })
  })
}

module "printer_cetus2" {
  source = "./modules/3d_printer"

  ceph_user_id    = data.vault_kv_secret_v2.ceph.data.user_id
  ceph_user_key   = data.vault_kv_secret_v2.ceph.data.user_key
  ceph_cluster_id = data.vault_kv_secret_v2.ceph.data.cluster_id

  printer_name          = "cetus2"
  klipper_img_version   = local.klipper_img_version
  moonraker_img_version = local.moonraker_img_version

  # Config files specific to this printer, merged with the common list.
  printer_configs = merge(local.common_configs, {
    "main_printer.cfg"     = file("${local.tmpldir}/cetus2/main_printer.cfg")
    "macros/macros.cfg"    = file("${local.tmpldir}/cetus2/macros.cfg")
    "macros/mixing.cfg"    = file("${local.tmpldir}/cetus2/mixing.cfg")
    "pins/cetus2_pins.cfg" = file("${local.tmpldir}/pins/cetus2_pins.cfg")
    "moonraker.conf" = templatefile("${local.tmpldir}/common/moonraker.conf", {
      power_relay_gpio = "gpio18"
    })
  })
}
