
module "printer_otrmo" {
  source = "./modules/3d_printer"

  ceph_user_id    = data.vault_kv_secret_v2.ceph.data.user_id
  ceph_user_key   = data.vault_kv_secret_v2.ceph.data.user_key
  ceph_cluster_id = data.vault_kv_secret_v2.ceph.data.cluster_id

  printer_name          = "otrmo"
  printer_hostname      = "cetus2"
  klipper_img_version   = var.klipper_img_version
  moonraker_img_version = var.moonraker_img_version

  # Config files specific to this printer, merged with the common list.
  printer_configs = merge(local.common_configs, {
    "main_printer.cfg"           = file("${local.tmpldir}/otrmo/main_printer.cfg")
    "macros/macros.cfg"          = file("${local.tmpldir}/otrmo/macros.cfg")
    "macros/mixing_extruder.cfg" = file("${local.tmpldir}/common/mixing_extruder.cfg")
    "pins/skr_1_4.cfg"           = file("${local.tmpldir}/pins/skr_1_4.cfg")

    "moonraker.conf" = templatefile("${local.tmpldir}/common/moonraker.conf", {
      power_relay_gpio = "gpio18"
    })
  })

  printer_conditional_configs = [
    {
      out_file = "toolhead.cfg"
      options = [
        {
          # Cetus2 toolhead with LGX Lite v2 extruders
          key       = "toolhead/cetus2"
          condition = "eq (keyOrDefault \"apps/3d_printers/otrmo_settings/toolhead\" \"dragonace\") \"cetus2\""
          content   = file("${local.tmpldir}/otrmo/toolhead_cetus2.cfg")
        },
        {
          # Mailbox toolhead w/Revo Voron
          key       = "toolhead/mailbox"
          condition = "eq (keyOrDefault \"apps/3d_printers/otrmo_settings/toolhead\" \"dragonace\") \"mailbox\""
          content = join("\n", [
            # Main toolhead config
            templatefile("${local.tmpldir}/otrmo/toolhead_mailbox.cfg", {
              orbitool_mcu_name = "orbitool"
            }),
            # Orbitool O2 board via USB
            templatefile("${local.tmpldir}/pins/orbitool_o2.cfg", {
              mcu_name   = "orbitool"
              mcu_serial = "/dev/serial/by-id/usb-Klipper_stm32f042x6_23002E000C43304E42323620-if00"
            }),
          ])
        },
        {
          # Dragonburner toolhead w/Dragon Ace + Meltzone extender
          key       = "toolhead/dragonace"
          condition = "eq (keyOrDefault \"apps/3d_printers/otrmo_settings/toolhead\" \"dragonace\") \"dragonace\""
          content   = join("\n", [
            templatefile("${local.tmpldir}/otrmo/toolhead_dragonace.cfg", {
              orbitool_mcu_name = "orbitool"
            }),
            # Orbitool O2S board via USB
            templatefile("${local.tmpldir}/pins/orbitool_o2s.cfg", {
              mcu_name   = "orbitool"
              mcu_serial = "/dev/serial/by-id/usb-Klipper_stm32f072xb_430032001657475534393420-if00"
              fan_pins = 2
              hotend_fan = "true"
            }),
            # Orbitool Sensor board via Orbitool board
            templatefile("${local.tmpldir}/pins/orbiter_sensor_2.cfg", {
              mcu_name   = "orbitool"
            }),
            # bd_pressure strain gauge via USB
            # templatefile("${local.tmpldir}/pins/bd_pressure.cfg", {
            #   mcu_name   = "orbitool"
            # })
          ])
        }
      ]
    }
  ]
}
