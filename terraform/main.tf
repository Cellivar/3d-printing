variable "klipper_img_version" {
  default = "81de9a8615df667ae2ea6d2b0f9204e7f3b09bcc"
}

variable "moonraker_img_version" {
  default = "v0.9.2"
}

locals {
  tmpldir = "${path.module}/../configs/klipper"
  jobdir = "${path.module}/job_templates"

  fluidd_img_version    = "v1.30.6"
  spoolman_img_version  = "0.20"
  manyfold_img_version  = "0.88.0"

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
