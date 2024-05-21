## Shared services between printers

data "vault_kv_secret_v2" "spoolman" {
  mount = "secret"
  name  = "apps/spoolman"
}

resource "postgresql_role" "spoolman" {
  name     = data.vault_kv_secret_v2.spoolman.data.DB_USERNAME
  password = data.vault_kv_secret_v2.spoolman.data.DB_PASSWORD
  login    = true
}

resource "postgresql_database" "spoolman" {
  name  = "spoolman"
  owner = postgresql_role.spoolman.name

  encoding = "UTF8"
}

resource "nomad_job" "printer-services" {
  jobspec = templatefile(
    "${local.tmpldir}/printer_services.nomad.hcl",
    {
      fluidd_img_version   = local.fluidd_img_version
      spoolman_img_version = local.spoolman_img_version
      database_name        = postgresql_database.spoolman.name
    }
  )
}
