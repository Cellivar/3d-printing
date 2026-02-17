variable "registry" {
  default = "zotoci.squeak.house"
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
  context = "./kalico"
  platforms = ["linux/arm64"]
  target = "run"

  output = [
    "type=image,push=true,name=${registry}/cellivar/klipper:latest",
    "type=image,push=true,name=${registry}/cellivar/klipper:${klipper_tag}"
  ]
}

target "klipper-flash" {
  context = "./kalico"
  platforms = ["linux/arm64"]
  target = "build-hostmcu"

  output = [
    "type=image,push=true,name=${registry}/cellivar/klipper-flash:latest",
    "type=image,push=true,name=${registry}/cellivar/klipper-flash:${klipper_tag}"
  ]
}

group "printer" {
  targets = ["moonraker", "klipper"]
}

## A container for touchscreen-based single-webpage kiosks.

variable "xkiosk_tag" {
  default = "0.0.2"
}

target "xkiosk" {
  context = "./xkiosk"
  platforms = ["linux/arm64", "linux/amd64"]

  output = [
    "type=image,push=true,name=${registry}/cellivar/xkiosk:latest",
    "type=image,push=true,name=${registry}/cellivar/xkiosk:${xkiosk_tag}"
  ]
}

group "display" {
  targets = ["xkiosk"]
}
