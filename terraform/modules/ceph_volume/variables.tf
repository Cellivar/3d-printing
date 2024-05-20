variable "name" {
  type        = string
  description = "The name of the volume, also used as the volume ID"
}

variable "nomad_plugin_id" {
  type        = string
  description = "The name of the nomad plugin handling CSI interop."
  default     = "ceph-csi"
}

variable "capacity_min" {
  type        = string
  description = "Minimum size of the volume. Ex: 10G"
  default     = "1G"
}

variable "capacity_max" {
  type        = string
  description = "Max size of the volume. Ex: 100G"
  default     = "10G"
}

variable "username" {
  type        = string
  sensitive   = true
  description = "Username to connect to Ceph with"
}

variable "user_key" {
  type        = string
  sensitive   = true
  description = "User Key to connect to Ceph with"
}

variable "cluster_id" {
  type        = string
  sensitive   = true
  description = "The Cluster ID the volume should be placed on"
}
