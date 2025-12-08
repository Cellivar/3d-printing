
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
    "pins/fysetc_hotkey.cfg" = templatefile("${local.tmpldir}/pins/fysetc_hotkey.cfg", {
      mcu_name     = "fysetc_hotkey"
      mcu_serial   = "/dev/serial/by-id/usb-Klipper_rp2040_E66058919F8E7E30-if00"
      button_count = 5
    })
  })

  printer_conditional_configs = [
    {
      out_file = "pins/ebb36.cfg"
      options = [
        {
          # RapidBurner toolhead w/Dragon Ace
          key       = "pins/ebb36_d1d"
          condition = "eq (keyOrDefault \"apps/3d_printers/bildhauerkabine_settings/toolhead\" \"revo\") \"dragon\""
          content = templatefile("${local.tmpldir}/pins/ebb36.cfg", {
            mcu_name    = "ebb36"
            canbus_uuid = "ad5151bfad1d"
          })
        },
        {
          # DragonBurner toolhead w/Revo Voron
          key       = "pins/ebb36_62f"
          condition = "eq (keyOrDefault \"apps/3d_printers/bildhauerkabine_settings/toolhead\" \"revo\") \"revo\""
          content = templatefile("${local.tmpldir}/pins/ebb36.cfg", {
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
          content = templatefile("${local.tmpldir}/bildhauerkabine/toolhead_dragon.cfg", {
            mcu_name    = "ebb36"
            canbus_uuid = "ad5151bfad1d"
          })
        },
        {
          # DragonBurner toolhead w/Revo Voron
          key       = "toolhead/revo"
          condition = "eq (keyOrDefault \"apps/3d_printers/bildhauerkabine_settings/toolhead\" \"revo\") \"revo\""
          content = templatefile("${local.tmpldir}/bildhauerkabine/toolhead_revo.cfg", {
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
          key       = "sensors/toolhead_voc"
          condition = "eq (keyOrDefault \"apps/3d_printers/bildhauerkabine_settings/sensors/toolhead_voc\" \"true\") \"true\""
          content = templatefile("${local.tmpldir}/common/nevermore_sensor.cfg", {
            sensor_name = "toolhead"
            i2c_mcu     = "ebb36"
            i2c_bus     = "i2c3_PB3_PB4"
          })
        }
      ]
    }
  ]
}
