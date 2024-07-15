variable "registry" {
  default = "docker.squeak.house"
}

variable "moonraker_tag" {}
variable "klipper_tag" {}

target "moonraker" {
  context = "./moonraker"
  platforms = ["linux/arm64"]
  target = "run"

  output = [
    "type=image,push=true,name=${registry}/cellivar/moonraker:latest",
    "type=image,push=true,name=${registry}/cellivar/moonraker:${moonraker_tag}"
  ]
}

target "klipper" {
  context = "./klipper"
  platforms = ["linux/arm64"]
  target = "run"

  output = [
    "type=image,push=true,name=${registry}/cellivar/klipper:latest",
    "type=image,push=true,name=${registry}/cellivar/klipper:${klipper_tag}"
  ]
}

target "klipper-hostmcu" {
  context = "./klipper"
  platforms = ["linux/arm64"]
  target = "hostmcu"

  output = [
    "type=image,push=true,name=${registry}/cellivar/klipper-hostmcu:latest",
    "type=image,push=true,name=${registry}/cellivar/klipper-hostmcu:${klipper_tag}"
  ]
}

group "default" {
  targets = ["moonraker", "klipper", "klipper-hostmcu"]
}
