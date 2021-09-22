locals {
  vault_user_data = templatefile(
    var.user_supplied_userdata_path != null ? var.user_supplied_userdata_path : "${path.module}/templates/install_vault.sh.tpl",
    {
      crypto_key            = var.crypto_key
      key_ring              = var.key_ring
      leader_tls_servername = var.leader_tls_servername
      location              = var.location
      project               = var.project_id
      resource_name_prefix  = var.resource_name_prefix
      tls_secret_id         = var.tls_secret_id
      vault_version         = var.vault_version
    }
  )
}
