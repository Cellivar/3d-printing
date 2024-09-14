
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
    "main_printer.cfg"           = file("${local.tmpldir}/cetus2/main_printer.cfg")
    "macros/macros.cfg"          = file("${local.tmpldir}/cetus2/macros.cfg")
    "macros/mixing_extruder.cfg" = file("${local.tmpldir}/common/mixing_extruder.cfg")
    "pins/cetus2_pins.cfg"       = file("${local.tmpldir}/pins/cetus2_pins.cfg")

    "moonraker.conf" = templatefile("${local.tmpldir}/common/moonraker.conf", {
      power_relay_gpio = "gpio18"
    })
    "pins/klipper_expander_pins.cfg" = templatefile("${local.tmpldir}/pins/klipper_expander_pins.cfg", {
      mcu_name = "kehead"
      mcu_serial = "/dev/serial/by-id/usb-Klipper_stm32f042x6_0A8015000A4330534E373320-if00"
    })
  })

  printer_conditional_configs = [
    {
      out_file = "toolhead.cfg"
      options = [
        {
          # Cetus2 toolhead with LGX Lite v2 extruders
          key       = "toolhead/cetus2"
          condition = "eq (keyOrDefault \"apps/3d_printers/cetus2_settings/toolhead\" \"mailbox\") \"cetus2\""
          content   = templatefile("${local.tmpldir}/cetus2/toolhead_cetus2.cfg", {
          })
        },
        {
          # Mailbox toolhead w/Revo Voron
          key       = "toolhead/mailbox"
          condition = "eq (keyOrDefault \"apps/3d_printers/cetus2_settings/toolhead\" \"mailbox\") \"mailbox\""
          content   = templatefile("${local.tmpldir}/cetus2/toolhead_mailbox.cfg", {
          })
        }
      ]
    }
  ]
}
