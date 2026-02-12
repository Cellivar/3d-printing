variable "klipper_img_version" {
  type        = string
  description = "The docker image tag for Klipper, see https://github.com/mkuf/prind"
}

variable "moonraker_img_version" {
  type        = string
  description = "The docker image tag for Moonraker, see https://github.com/mkuf/prind"
}

## Printer information

variable "printer_name" {
  type        = string
  description = "The name of the printer"
}

variable "printer_hostname" {
  type        = string
  description = "The hostname of the printer node, used for Nomad scheduling constraints"
}

variable "printer_configs" {
  type        = map(string)
  description = "The map of config files that apply to this printer"
}

variable "printer_conditional_configs" {
  type = list(object({
    out_file = string
    options = list(object({
      key       = string
      content   = string
      condition = string
    }))
  }))
  description = "The map of config files that conditionally apply to this printer. Conditions must equal true to be applied."
  default     = []
}

## Ceph storage volume information

variable "ceph_user_id" {
  type        = string
  description = "The Ceph user ID for managing the volume"
  sensitive   = true
}

variable "ceph_user_key" {
  type        = string
  description = "The Ceph user key for managing the volume"
  sensitive   = true
}

variable "ceph_cluster_id" {
  type        = string
  description = "The Ceph cluster ID the volume is placed on."
  sensitive   = true
}
