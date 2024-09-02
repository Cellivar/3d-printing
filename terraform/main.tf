variable "klipper_img_version" {
  default = "81de9a8615df667ae2ea6d2b0f9204e7f3b09bcc"
}

variable "moonraker_img_version" {
  default = "v0.9.2"
}

locals {
  tmpldir = "${path.module}/../configs/klipper"
  jobdir = "${path.module}/job_templates"

  fluidd_img_version    = "v1.30.1"
  spoolman_img_version  = "0.18"
  manyfold_img_version  = "0.67.0"

  # Config files expected to be on every printer.
  common_configs = {
    "main.cfg"               = file("${local.tmpldir}/common/main.cfg")
    "common/fluidd.cfg"      = file("${local.tmpldir}/common/fluidd.cfg")
    "common/timelapse.cfg"   = file("${local.tmpldir}/common/timelapse.cfg")
    "macros/util_macros.cfg" = file("${local.tmpldir}/common/util_macros.cfg")
    "macros/heatsoak.cfg"    = file("${local.tmpldir}/common/heatsoak.cfg")
    "macros/spoolman.cfg"    = file("${local.tmpldir}/common/spoolman.cfg")
    "macros/common.cfg"      = file("${local.tmpldir}/common/common_macros.cfg")
    "macros/tunes.cfg"       = file("${local.tmpldir}/common/tunes.cfg")
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
  klipper_img_version   = var.klipper_img_version
  moonraker_img_version = var.moonraker_img_version

  # Config files specific to this printer, merged with the common list.
  printer_configs = merge(local.common_configs, {
    "main_printer.cfg"          = file("${local.tmpldir}/bildhauerkabine/main_printer.cfg")
    "macros/macros.cfg"         = file("${local.tmpldir}/bildhauerkabine/macros.cfg")
    "macros/probe_dock.cfg"     = file("${local.tmpldir}/common/probe_dock.cfg")
    "pins/octopus_1_1_pins.cfg" = file("${local.tmpldir}/pins/octopus_1_1_pins.cfg")
    "pins/mini12864.cfg"        = file("${local.tmpldir}/pins/mini12864.cfg")

    "moonraker.conf" = templatefile("${local.tmpldir}/common/moonraker.conf", {
      power_relay_gpio = "!gpio18"
    })
    "common/bttsfs2.cfg" = templatefile("${local.tmpldir}/common/bttsfs2.cfg", {
      motion_pin       = "SENSOR6"
      switch_pin       = "SENSOR5"
      sensor_name      = "bttsfs2"
      related_extruder = "extruder"
    })
  })

  printer_conditional_configs = [
    {
      out_file = "pins/ebb36.cfg"
      options  = [
        {
          # RapidBurner toolhead w/Dragon Ace
          key       = "pins/ebb36_d1d"
          condition = "eq (keyOrDefault \"apps/3d_printers/bildhauerkabine_settings/toolhead\" \"revo\") \"dragon\""
          content   = templatefile("${local.tmpldir}/pins/ebb36.cfg", {
            mcu_name    = "ebb36"
            canbus_uuid = "ad5151bfad1d"
          })
        },
        {
          # DragonBurner toolhead w/Revo Voron
          key       = "pins/ebb36_62f"
          condition = "eq (keyOrDefault \"apps/3d_printers/bildhauerkabine_settings/toolhead\" \"revo\") \"revo\""
          content   = templatefile("${local.tmpldir}/pins/ebb36.cfg", {
            mcu_name    = "ebb36"
            canbus_uuid = "cb63bcbb762f"
          })
        }
      ]
    },
    {
      out_file = "toolhead.cfg"
      options = [
        {
          # RapidBurner toolhead w/Dragon Ace
          key       = "toolhead/dragon"
          condition = "eq (keyOrDefault \"apps/3d_printers/bildhauerkabine_settings/toolhead\" \"revo\") \"dragon\""
          content   = templatefile("${local.tmpldir}/bildhauerkabine/toolhead_dragon.cfg", {
            mcu_name    = "ebb36"
            canbus_uuid = "ad5151bfad1d"
          })
        },
        {
          # DragonBurner toolhead w/Revo Voron
          key       = "toolhead/revo"
          condition = "eq (keyOrDefault \"apps/3d_printers/bildhauerkabine_settings/toolhead\" \"revo\") \"revo\""
          content   = templatefile("${local.tmpldir}/bildhauerkabine/toolhead_revo.cfg", {
            mcu_name    = "ebb36"
            canbus_uuid = "cb63bcbb762f"
          })
        }
      ]
    },
    {
      out_file = "common/toolhead_voc.cfg"
      options = [
        {
          key = "sensors/toolhead_voc"
          condition = "eq (keyOrDefault \"apps/3d_printers/bildhauerkabine_settings/sensors/toolhead_voc\" \"true\") \"true\""
          content = templatefile("${local.tmpldir}/common/nevermore_sensor.cfg", {
            sensor_name = "toolhead"
            i2c_mcu = "ebb36"
            i2c_bus = "i2c3_PB3_PB4"
          })
        }
      ]
    }
  ]
}

module "printer_cetus2" {
  source = "./modules/3d_printer"

  ceph_user_id    = data.vault_kv_secret_v2.ceph.data.user_id
  ceph_user_key   = data.vault_kv_secret_v2.ceph.data.user_key
  ceph_cluster_id = data.vault_kv_secret_v2.ceph.data.cluster_id

  printer_name          = "cetus2"
  klipper_img_version   = var.klipper_img_version
  moonraker_img_version = var.moonraker_img_version

  # Config files specific to this printer, merged with the common list.
  printer_configs = merge(local.common_configs, {
    "main_printer.cfg"     = file("${local.tmpldir}/cetus2/main_printer.cfg")
    "macros/macros.cfg"    = file("${local.tmpldir}/cetus2/macros.cfg")
    "macros/mixing.cfg"    = file("${local.tmpldir}/cetus2/mixing.cfg")
    "pins/cetus2_pins.cfg" = file("${local.tmpldir}/pins/cetus2_pins.cfg")

    "moonraker.conf" = templatefile("${local.tmpldir}/common/moonraker.conf", {
      power_relay_gpio = "gpio18"
    })
    # "pins/ercf_easy_brd.cfg" = templatefile("${local.tmpldir}/pins/ercf_easy_brd.cfg", {
    #   mcu_name = "ercf"
    #   mcu_serial = ""
    # })
  })
}
