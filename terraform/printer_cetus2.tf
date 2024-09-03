
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
