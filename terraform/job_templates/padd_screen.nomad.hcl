job "padd-screen" {
  # Ensure this gets priorty to run on the right device
  priority = 75

  group "padd-screen" {
    count = 1
    # If a network hiccup occurs this job should be allowed to reconnect gracefully
    # otherwise Nomad will immediately restart this job, causing problems.
    max_client_disconnect = "6h"

    constraint {
      # Only run this job on the printer node.
      attribute = "$${attr.unique.hostname}"
      value     = "intrepid"
    }

    restart {
      attempts = 300
      delay    = "5s"
      interval = "30m"
      mode     = "delay"
    }

    update {
      max_parallel      = 0
      min_healthy_time  = "5s"
      healthy_deadline  = "5m"
      progress_deadline = "10m"
      auto_revert       = false
      canary            = 0
    }

    task "xkiosk" {
      driver = "docker"
      config {
        image = "zotoci.squeak.house/cellivar/xkiosk:latest"
        command = "xeyes"
        cap_add = [ "SYS_TTY_CONFIG" ]
        volumes = [
          # If missing the touchscreen won't be found
          "/run/udev/data:/run/udev/data"
        ]
        devices = [
          {
            # Touchscreen input devices
            host_path = "/dev/input"
            container_path = "/dev/input"
          },
          {
            # Console management devices
            host_path = "/dev/console"
            container_path = "/dev/console"
          },
          {
            host_path = "/dev/tty"
            container_path = "/dev/tty"
          },
          {
            host_path = "/dev/tty1"
            container_path = "/dev/tty1"
          },
          {
            # Screen management devices
            host_path = "/dev/fb0"
            container_path = "/dev/fb0"
          },
          {
            host_path = "/dev/snd"
            container_path = "/dev/snd"
          },
          {
            host_path = "/dev/psaux"
            container_path = "/dev/psaux"
          }
        ]
      }

      env {
        DEFAULT_HOMEPAGE = "${homepage}"
        DISPLAY = ":0"
      }
    }
  }
}