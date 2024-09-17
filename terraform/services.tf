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

data "vault_kv_secret_v2" "manyfold" {
  mount = "secret"
  name  = "apps/manyfold"
}

resource "postgresql_role" "manyfold" {
  name     = data.vault_kv_secret_v2.manyfold.data.POSTGRES_USER
  password = data.vault_kv_secret_v2.manyfold.data.POSTGRES_PASSWORD
  login    = true
}

resource "postgresql_database" "manyfold" {
  name  = "manyfold"
  owner = postgresql_role.manyfold.name

  encoding = "UTF8"
}

module "manyfold_volume" {
  source = "./modules/ceph_volume"

  name            = "manyfold"
  capacity_max    = "50G"
  capacity_min    = "20G"
  username        = data.vault_kv_secret_v2.ceph.data.user_id
  user_key        = data.vault_kv_secret_v2.ceph.data.user_key
  cluster_id      = data.vault_kv_secret_v2.ceph.data.cluster_id
}

resource "nomad_job" "printer-services" {
  jobspec = templatefile(
    "${local.jobdir}/printer_services.nomad.hcl",
    {
      fluidd_img_version   = local.fluidd_img_version

      spoolman_img_version = local.spoolman_img_version
      spoolman_database    = postgresql_database.spoolman.name

      manyfold_img_version = local.manyfold_img_version
      manyfold_volume_name = module.manyfold_volume.volume_name
      manyfold_database    = postgresql_database.manyfold.name
    }
  )
}

# resource "nomad_job" "padd_screen" {
#   jobspec = templatefile(
#     "${local.jobdir}/padd_screen.nomad.hcl",
#     {
#       homepage = "https://fluidd.squeak.house"
#     }
#   )
# }