terraform {
  backend "consul" {
    path = "terraform/state/3d-printing/nomad_jobs"

    # Set as env vars
    # CONSUL_HTTP_TOKEN
    # CONSUL_HTTP_ADDR
  }

  required_providers {
  }

  required_version = "~> 1.6.2"
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
