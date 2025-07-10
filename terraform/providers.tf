terraform {
  backend "consul" {
    path = "terraform/state/3d-printing/nomad_jobs"

    # Set as env vars
    # CONSUL_HTTP_TOKEN
    # CONSUL_HTTP_ADDR
  }

  required_providers {
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "1.22.0"
    }
  }

  required_version = "~> 1.12.2"
}

provider "vault" {
  # Set as env vars
  # VAULT_ADDR
  # VAULT_TOKEN
}

provider "nomad" {
  # Set as env vars
  # NOMAD_ADDR
  # NOMAD_HTTP_AUTH
}

provider "consul" {
  datacenter = "squeakhouse"
  # Set as env vars
  # CONSUL_HTTP_TOKEN
  # CONSUL_HTTP_ADDR
}

data "vault_kv_secret_v2" "postgres_mgmt" {
  mount = "secret"
  name  = "apps/postgres/management"
}

provider "postgresql" {
  host = "postgres.squeak.house"
  port = 5432

  username = data.vault_kv_secret_v2.postgres_mgmt.data.username
  password = data.vault_kv_secret_v2.postgres_mgmt.data.password

  sslmode = "disable"
}
