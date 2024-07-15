job "Printer-${printer_name}" {
  datacenters = ["squeakhouse"]

  # Ensure this ends up on the printer node.
  priority = 75

  group "on-machine" {
    count = 1
    # If a network hiccup occurs this job should be allowed to reconnect gracefully
    # otherwise Nomad will immediately restart this job, causing problems.
    max_client_disconnect = "6h"

    constraint {
      # Only run this job on the printer node.
      attribute = "$${attr.unique.hostname}"
      value     = "${printer_name}"
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

    network {
      port "moonraker" { to = 7125 }
    }

    volume "printer_config" {
      type            = "csi"
      read_only       = false
      source          = "${csi_volume_name}"
      attachment_mode = "file-system"
      access_mode     = "single-node-writer"

      mount_options {
        fs_type = "ext4"
      }
    }

    task "config-update" {
      lifecycle {
        hook = "poststart"
        sidecar = true
      }

      driver = "docker"
      config {
        image = "docker.io/hashicorp/consul-template"
        # For local consul agent access
        network_mode = "host"
        args = ["-config", "/etc/consul-template.d/consul-template.hcl"]
        volumes = [
          "local/consul-template.hcl:/etc/consul-template.d/consul-template.hcl"
        ]
      }

      volume_mount {
        volume      = "printer_config"
        destination = "/var/printer_data"
      }

      template {
        destination   = "local/consul-template.hcl"
        change_mode   = "signal"
        change_signal = "SIGHUP"
        data = "{{ key \"${consul_template_key}\" }}"
      }
    }

    task "klipper" {
      driver = "docker"
      config {
        image = "docker.squeak.house/cellivar/klipper:${klipper_img_version}"
        # Klipper neds to talk to various devices directly
        volumes = [
          "/dev:/dev"
        ]
        # For can0 access
        privileged = true
        network_mode = "host"
      }

      volume_mount {
        volume      = "printer_config"
        destination = "/home/klipper/printer_data"
      }

      resources {
        cpu    = 1000
        memory = 200
        memory_max = 500
      }
    }

    task "moonraker" {
      driver = "docker"
      config {
        image = "docker.squeak.house/cellivar/moonraker:${moonraker_img_version}"
        ports = ["moonraker"]

        # Enable GPIO control
        group_add = ["dialout"]
        devices = [
          {
            host_path = "/dev/gpiochip0"
            container_path = "/dev/gpiochip0"
          },
          {
            host_path = "/dev/gpiochip1"
            container_path = "/dev/gpiochip1"
          },
          {
            host_path = "/dev/gpiomem"
            container_path = "/dev/gpiomem"
          }
        ]
      }

      env {
        # Don't log to file, let Nomad handle log collection.
        MOONRAKER_DISABLE_FILE_LOG = "y"
      }

      volume_mount {
        volume      = "printer_config"
        destination = "/home/moonraker/printer_data"
      }

      resources {
        cpu    = 100
        memory = 100
        memory_max = 500
      }

      service {
        name = "$${TASKGROUP}-$${TASK}"
        port = "moonraker"
        address  = "$${attr.unique.network.ip-address}"
        tags = [
          "apps",
          "urlprefix-${printer_name}-moonraker.squeak.house:80/ redirect=301,https://${printer_name}-moonraker.squeak.house$path",
          "urlprefix-${printer_name}-moonraker.squeak.house/",
          "hostname"
        ]
        meta {
          hostname = "${printer_name}-moonraker.squeak.house"
        }
        check {
          name     = "alive"
          type     = "http"
          path     = "/"
          interval = "10s"
          timeout  = "5s"
        }
      }
    }
  }
}
