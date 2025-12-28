locals {
  printer_afc_config = templatefile("${local.tmpldir}/bildhauerkabine/afc.cfg", {
    afc_mcu_name = "Turtle_1"
  })
  printer_afc_board = templatefile("${local.tmpldir}/pins/afc_lite.cfg", {
    mcu_name   = "Turtle_1"
    mcu_serial = "/dev/serial/by-id/usb-Klipper_stm32h723xx_2D0026000A51333033333834-if00"

    afc_bowden_length = 1005.0

    rgb_led2_enabled = true
    rgb_led2_count   = 64
    rgb_led3_enabled = false
    rgb_led3_count   = 0
    rgb_led4_enabled = false
    rgb_led4_count   = 0

    lanes = [
      {
        id       = 1
        dist_hub = 170.0
      },
      {
        id       = 2
        dist_hub = 115.0
      },
      {
        id       = 3
        dist_hub = 115.0
      },
      {
        id       = 4
        dist_hub = 170.0
      }
    ]
  })
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
    "main_printer.cfg"  = file("${local.tmpldir}/bildhauerkabine/main_printer.cfg")
    "macros/macros.cfg" = file("${local.tmpldir}/bildhauerkabine/macros.cfg")
    "pins/octopus_1_1_pins.cfg" = file("${local.tmpldir}/pins/octopus_1_1_pins.cfg")
    "pins/mini12864.cfg"        = file("${local.tmpldir}/pins/mini12864.cfg")

    # The probe is on a servo arm to attach and detach it from the toolhead.
    "common/servo_arm.cfg" = templatefile("${local.tmpldir}/common/probe_dock.cfg", {
      servo_name         = "probe_dock"
      servo_pin          = "RASPI_RX2"
      extended_angle     = 0
      retracted_angle    = 256
      servo_move_time_ms = 750
    })

    # The printer has a mounted brush and filament cutter arm. Two servos use the
    # same output pins for both, with a 1/4 turn to extend and retract both.
    "common/servo_arm.cfg" = templatefile("${local.tmpldir}/common/servo_arm.cfg", {
      servo_name         = "brush_arm"
      servo_pin          = "RASPI_TX2"
      extended_angle     = 0
      retracted_angle    = 256
      servo_move_time_ms = 750
    })

    # AFC macros
    "macros/afc_macros.cfg" = file("${local.tmpldir}/common/afc/afc_macros.cfg")
    "macros/afc_brush.cfg"  = file("${local.tmpldir}/common/afc/brush.cfg")
    "macros/afc_cut.cfg"    = file("${local.tmpldir}/common/afc/cut.cfg")
    "macros/afc_kick.cfg"   = file("${local.tmpldir}/common/afc/kick.cfg")
    "macros/afc_park.cfg"   = file("${local.tmpldir}/common/afc/park.cfg")
    "macros/afc_poop.cfg"   = file("${local.tmpldir}/common/afc/poop.cfg")

    "moonraker.conf" = templatefile("${local.tmpldir}/common/moonraker.conf", {
      power_relay_gpio = "!gpio18"
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
    },
    {
      # The main AFC config must load before the board, order matters for these.
      out_file = "afc/a_afc.cfg"
      options = [
        {
          key       = "afc/afc_cfg"
          condition = "eq (keyOrDefault \"apps/3d_printers/bildhauerkabine_settings/external/afc1\" \"true\") \"true\""
          content   = local.printer_afc_config
        },
        {
          key       = "afc/manual"
          condition = "eq (keyOrDefault \"apps/3d_printers/bildhauerkabine_settings/external/afc1\" \"true\") \"false\""
          content   = file("${local.tmpldir}/common/filament_manual.cfg")
        }
      ]
    },
    {
      out_file = "afc/b_afc_board.cfg"
      options = [
        {
          key       = "pins/afc_cfg"
          condition = "eq (keyOrDefault \"apps/3d_printers/bildhauerkabine_settings/external/afc1\" \"true\") \"true\""
          content   = local.printer_afc_board
        }
      ]
    },
  ]
}
