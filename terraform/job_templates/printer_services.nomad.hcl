job "3DPrinter-Services" {
  datacenters = ["squeakhouse"]

  group "control-plane" {
    count = 1

    restart {
      attempts = 300
      delay    = "5s"
      interval = "30m"
      mode     = "delay"
    }

    network {
      port "fluidd" { to = 80 }
    }

    task "fluidd" {
      driver = "docker"
      config {
        image = "ghcr.io/fluidd-core/fluidd:${fluidd_img_version}"
        ports = ["fluidd"]
      }

      resources {
        cpu    = 500
        memory = 50
      }

      service {
        name = "$${TASK}"
        port = "fluidd"
        tags = [
          "apps",
          "urlprefix-fluidd.squeak.house:80/ redirect=301,https://fluidd.squeak.house$path",
          "urlprefix-fluidd.squeak.house/",
          "hostname--fluidd.squeak.house"
        ]
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

  group "manyfold" {
    count = 1

    restart {
      attempts = 300
      delay    = "5s"
      interval = "30m"
      mode     = "delay"
    }

    network {
      port "manyfold" { to = 3214 }
      port "redis" { to = 6379 }
    }

    volume "manyfold" {
      type            = "csi"
      read_only       = false
      source          = "${manyfold_volume_name}"
      attachment_mode = "file-system"
      access_mode     = "single-node-writer"

      mount_options {
        fs_type = "ext4"
      }
    }

    task "manyfold" {
      driver = "docker"
      config {
        image = "ghcr.io/manyfold3d/manyfold:${manyfold_img_version}"
        ports = ["manyfold"]
      }

      resources {
        cpu        = 500
        memory     = 1000
        memory_max = 2000
      }

      volume_mount {
        volume      = "manyfold"
        destination = "/libraries"
      }

      template {
        destination = "secrets/vars.env"
        change_mode = "restart"
        env         = true
        data        = <<-EOH
          # {{ with secret "secret/apps/manyfold" }}

          SECRET_KEY_BASE="{{ .Data.data.SECRET_KEY_BASE }}"
          PUID: 1000
          PGID: 1000

          DATABASE_ADAPTER: postgresql

          DATABASE_HOST="postgres.squeak.house:5432"
          DATABASE_USER="{{ .Data.data.POSTGRES_USER }}"
          DATABASE_PASSWORD="{{ .Data.data.POSTGRES_PASSWORD }}"
          DATABASE_NAME="${manyfold_database}"

          REDIS_URL="redis://{{ env "NOMAD_ADDR_redis" }}/1"

          PUBLIC_HOSTNAME="manyfold.squeak.house"
          # {{ end }}
          EOH
      }

      vault {
        policies    = ["ecowitt-policy"]
        change_mode = "restart"
      }

      service {
        name = "$${TASK}"
        port = "manyfold"
        tags = [
          "apps",
          "urlprefix-manyfold.squeak.house:80/ redirect=301,https://manyfold.squeak.house$path",
          "urlprefix-manyfold.squeak.house/",
          "hostname--manyfold.squeak.house"
        ]
        check {
          name     = "alive"
          type     = "http"
          path     = "/health"
          interval = "10s"
          timeout  = "5s"
        }
      }
    }

    task "manyfold-redis" {
      driver = "docker"
      config {
        image = "redis:7"
        ports = ["redis"]
      }

      resources {
        cpu    = 500
        memory = 500
      }
    }
  }

  group "spoolman" {
    count = 1

    restart {
      attempts = 300
      delay    = "5s"
      interval = "30m"
      mode     = "delay"
    }

    network {
      port "spoolman" { to = 7912 }
    }

    task "spoolman" {
      driver = "docker"
      config {
        image = "ghcr.io/donkie/spoolman:${spoolman_img_version}"
        ports = ["spoolman"]
      }

      resources {
        cpu    = 500
        memory = 500
      }

      service {
        name = "$${TASK}"
        port = "spoolman"
        tags = [
          "apps",
          "urlprefix-spoolman.squeak.house:80/ redirect=301,https://spoolman.squeak.house$path",
          "urlprefix-spoolman.squeak.house/",
          "hostname--spoolman.squeak.house"
        ]
        check {
          name     = "alive"
          type     = "http"
          path     = "/"
          interval = "10s"
          timeout  = "5s"
        }
      }

      vault {
        policies    = ["ecowitt-policy"]
        change_mode = "restart"
      }

      template {
        destination = "secrets/vars.env"
        change_mode = "restart"
        env         = true
        data        = <<-EOH
          # App config
          # {{ with secret "secret/apps/spoolman" }}
          # Host and port to listen on
          SPOOLMAN_HOST=0.0.0.0
          SPOOLMAN_PORT=7912

          # DB Type: sqlite, mysql, postgresql, cockroachdb
          # Default if not set: sqlite
          SPOOLMAN_DB_TYPE=postgres

          SPOOLMAN_DB_HOST=postgres.squeak.house
          SPOOLMAN_DB_PORT=5432
          SPOOLMAN_DB_NAME="${spoolman_database}"
          SPOOLMAN_DB_USERNAME="{{ .Data.data.DB_USERNAME }}"
          SPOOLMAN_DB_PASSWORD="{{ .Data.data.DB_PASSWORD }}"

          # Query parameters for the database connection, e.g. set to `unix_socket=/path/to/mysql.sock` to connect using a MySQL socket.
          #SPOOLMAN_DB_QUERY=

          # Logging level: DEBUG, INFO, WARNING, ERROR, CRITICAL
          # Logs will only be reported if the level is higher than the level set here
          # Default if not set: INFO
          #SPOOLMAN_LOGGING_LEVEL=INFO

          # Automatic nightly backup for SQLite databases
          # Default if not set: TRUE
          #SPOOLMAN_AUTOMATIC_BACKUP=TRUE

          # Data directory, where the SQLite database is stored
          # Default if not set: /home/<user>/.local/share/spoolman
          #SPOOLMAN_DIR_DATA=/home/pi/spoolman_data

          # Backup directory, where the SQLite database backups are stored
          # Default if not set: /home/<user>/.local/share/spoolman/backups
          #SPOOLMAN_DIR_BACKUPS=/home/pi/spoolman_data/backups

          # Log directory
          # Default if not set: /home/<user>/.local/share/spoolman
          #SPOOLMAN_DIR_LOGS=/home/pi/spoolman_data

          # Change base path
          # Set this if you want to host Spoolman at a sub-path
          # If you want the root to be e.g. myhost.com/spoolman
          # Then set this to /spoolman
          #SPOOLMAN_BASE_PATH=

          # Enable Collect Prometheus metrics at database
          # Default: FALSE
          #SPOOLMAN_METRICS_ENABLED=TRUE

          # Collect items (filaments, materials, etc.) from an external database
          # Set this to a URL of an external database. Set to an empty string to disable
          # Default: https://donkie.github.io/SpoolmanDB/
          #EXTERNAL_DB_URL=https://myhost.com/spoolmandb/
          # Sync interval in seconds, set to 0 to disable automatic sync. It will only sync on start-up then.
          # Default: 3600
          #EXTERNAL_DB_SYNC_INTERVAL=3600

          # Enable debug mode
          # If enabled, the client will accept requests from any host
          # This can be useful when developing, but is also a security risk
          # Default: FALSE
          #SPOOLMAN_DEBUG_MODE=TRUE

          # UID and GID of the user in the docker container
          # These only make sense if you are running Spoolman in a docker container
          # Default if not set: 1000
          #PUID=1000
          #PGID=1000

          # {{ end }}
          EOH
      }
    }
  }

  group "chromium_fluidd" {
    count = 1

    restart {
      attempts = 300
      delay    = "5s"
      interval = "30m"
      mode     = "delay"
    }

    constraint {
      attribute = "$${attr.cpu.arch}"
      value     = "amd64"
    }

    network {
      port "vnc" { to = 5901 }
      port "webvnc" { to = 6901 }
    }

    task "chromium" {
      driver = "docker"
      config {
        image = "accetto/ubuntu-vnc-xfce-chromium-g3:20.04"
        ports = ["vnc", "webvnc"]
        volumes = [
          "local/chromium-browser.init:/home/headless/.chromium-browser.init"
        ]

        shm_size = ${256 * 1024 * 1024} # bytes
      }

      resources {
        cpu    = 500
        memory = 1024
      }

      service {
        name = "$${TASK}"
        port = "vnc"
        tags = [
          "apps",
          "urlprefix-chromium_fluidd.squeak.house:80/ redirect=301,https://chromium_fluidd.squeak.house$path",
          "urlprefix-chromium_fluidd.squeak.house/",
          "hostname--chromium_fluidd.squeak.house"
        ]
      }

      service {
        name = "$${TASK}-webvnc"
        port = "webvnc"
        tags = [
          "apps",
          "urlprefix-chromium_fluidd_web.squeak.house:80/ redirect=301,https://chromium_fluidd_web.squeak.house$path",
          "urlprefix-chromium_fluidd_web.squeak.house/",
          "hostname--chromium_fluidd_web.squeak.house"
        ]
        check {
          name     = "alive"
          type     = "http"
          path     = "/"
          interval = "10s"
          timeout  = "5s"
        }
      }

      vault {
        policies    = ["ecowitt-policy"]
        change_mode = "restart"
      }

      template {
        destination = "secrets/var.env"
        change_mode = "restart"
        env = true
        data = <<-EOH
        # {{ with secret "secret/apps/printers/fluidd_chromium" }}
        VNC_PW={{ .Data.data.vnc_password }}
        # {{ end }}
        VNC_RESOLUTION=400x1280
        NOVNC_HEARTBEAT=30
        EOH
      }

      template {
        destination = "local/chromium-browser.init"
        perms = "755"
        data = <<-EOH
        CHROMIUM_FLAGS='--no-sandbox --disable-gpu --user-data-dir --window-size=400,1280 --window-position=0,0 --kiosk https://fluidd.squeak.house'
        EOH
      }
    }
  }
}
