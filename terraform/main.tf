variable "klipper_img_version" {
  default = "b7233d1197d9a2158676ad39d02b80f787054e20"
}

variable "moonraker_img_version" {
  default = "v0.9.3"
}

locals {
  tmpldir = "${path.module}/../configs/klipper"
  jobdir = "${path.module}/job_templates"

  fluidd_img_version    = "v1.34.2"
  spoolman_img_version  = "0.22"
  manyfold_img_version  = "0.111.2"

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
