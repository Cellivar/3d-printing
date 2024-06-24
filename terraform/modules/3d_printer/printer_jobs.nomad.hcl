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

    task "config-setup" {
      lifecycle {
        hook    = "prestart"
        sidecar = false
      }

      driver = "exec"
      config {
        command = "bash"
        args = [
          "./local/config-setup.sh",
        ]
      }

      template {
        destination = "local/config-setup.sh"
        change_mode = "noop"
        perms       = "555"
        data        = <<EOH
#!/bin/bash
# This script sets up the config directory so that other jobs can start up.
# First the directory structure:
mkdir -p ${config_path}
mkdir -p ${printer_data_path}/run

# The printer.cfg file is required to boot, but is overwritten by Klipper too.
# Create it only if it's missing. Everything else is in or referenced from main.cfg.
[ -f ${config_path}/printer.cfg ] || echo '[include main.cfg]' > ${config_path}/printer.cfg

# Change ownership so the docker containers can all interact with it
chown -R 1000:1000 ${printer_data_path}
chmod -R 777 ${printer_data_path}

EOH
      }

      volume_mount {
        volume      = "printer_config"
        destination = "${printer_data_path}"
      }

      resources {
        cpu    = 100
        memory = 200
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
        args = ["-config", "/etc/consul-template.d/consul-template.hcl"]
        volumes = [
          "local/consul-template.hcl:/etc/consul-template.d/consul-template.hcl"
        ]
      }

      volume_mount {
        volume      = "printer_config"
        destination = "${printer_data_path}"
      }

      template {
        destination   = "local/consul-template.hcl"
        change_mode   = "restart"
        data = <<EOF
consul {
  address = "{{ env "attr.unique.network.ip-address" }}:8500"
}

log_level = "info"

%{ for key,val in machine_configs }
template {
  destination = "${config_path}/${key}"
  perms       = "0666"
  left_delimiter  = "{!!{"
  right_delimiter = "}!!}"
  contents    = <<EOH
{{ key "${config_key_prefix}${key}" }}
EOH
}
%{ endfor }
EOF
      }
    }

    task "klipper" {
      driver = "docker"
      config {
        image = "docker.io/mkuf/klipper:${klipper_img_version}"
        # Klipper neds to talk to various devices directly
        volumes = [
          "/dev:/dev"
        ]
        # For can0 access
        privileged = true
        network_mode = "host"
        # Overrides so we can use our volume mount instead of the defaults.
        entrypoint = ["/opt/venv/bin/python"]
        command = "klipper/klippy/klippy.py"
        args = [
          "-I", "${printer_data_path}/run/klipper.tty",
          "-a", "${printer_data_path}/run/klipper.sock",
          "${printer_data_path}/config/printer.cfg" ]
      }

      volume_mount {
        volume      = "printer_config"
        destination = "${printer_data_path}"
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
        image = "docker.io/mkuf/moonraker:${moonraker_img_version}"
        ports = ["moonraker"]

        # TODO: Not sure if this is actually needed now..
        network_mode = "bridge"

        # Overrides so we can use our volume mount instead of the defaults.
        entrypoint = ["/opt/venv/bin/python"]
        command = "moonraker/moonraker/moonraker.py"
        args = ["-d", "${printer_data_path}"]
        volumes = [
          "local:/opt/klipper/config",
          "local:/opt/klipper/docs",
        ]
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
        destination = "${printer_data_path}"
      }

      template {
        destination = "local/empty.md"
        change_mode = "noop"
        data = "Nothing here!"
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
