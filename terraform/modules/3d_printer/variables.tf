variable "klipper_img_version" {
  type        = string
  description = "The docker image tag for Klipper, see https://github.com/mkuf/prind"
}

variable "moonraker_img_version" {
  type        = string
  description = "The docker image tag for Moonraker, see https://github.com/mkuf/prind"
}

variable "printer_name" {
  type        = string
  description = "The name of the printer"
}

variable "printer_configs" {
  type        = map(string)
  description = "The map of config files that apply to this printer"
}

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
