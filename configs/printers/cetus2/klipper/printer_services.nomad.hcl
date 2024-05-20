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
          "hostname"
        ]
        meta {
          hostname = "fluidd.squeak.house"
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
        memory = 50
      }

      service {
        name = "$${TASK}"
        port = "spoolman"
        tags = [
          "apps",
          "urlprefix-spoolman.squeak.house:80/ redirect=301,https://spoolman.squeak.house$path",
          "urlprefix-spoolman.squeak.house/",
          "hostname"
        ]
        meta {
          hostname = "spoolman.squeak.house"
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

      vault {
        policies    = ["ecowitt-policy"]
        change_mode = "restart"
      }

      template {
        destination = "secrets/vars.env"
        change_mode = "restart"
        env = true
        data = <<EOH
# App config
# {{ with secret "secret/apps/printers/spoolman" }}
# Host and port to listen on
SPOOLMAN_HOST=0.0.0.0
SPOOLMAN_PORT=7912

# DB Type: sqlite, mysql, postgresql, cockroachdb
# Default if not set: sqlite
SPOOLMAN_DB_TYPE=postgresql

# DB Setup, if not using sqlite
SPOOLMAN_DB_HOST=postgres.squeak.house
SPOOLMAN_DB_PORT=5432
SPOOLMAN_DB_NAME="{{ .Data.data.DB_NAME }}"
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
