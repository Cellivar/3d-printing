data "nomad_plugin" "ceph_plugin" {
  plugin_id             = var.nomad_plugin_id
  wait_for_registration = true
}

resource "nomad_csi_volume" "ceph_volume" {
  depends_on = [data.nomad_plugin.ceph_plugin]

  lifecycle {
    prevent_destroy = true
  }

  volume_id = var.name
  name      = var.name

  plugin_id = data.nomad_plugin.ceph_plugin.plugin_id

  capacity_max = var.capacity_max
  capacity_min = var.capacity_min

  capability {
    access_mode     = "single-node-writer"
    attachment_mode = "file-system"
  }

  secrets = {
    userID  = var.username
    userKey = var.user_key
  }

  parameters = {
    clusterID     = var.cluster_id
    pool          = "nomad"
    imageFeatures = "layering"
    mkfsOptions   = "-t ext4"
  }
}

output "volume_name" {
  value = nomad_csi_volume.ceph_volume.name
}
