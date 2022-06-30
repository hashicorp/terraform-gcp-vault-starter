resource "random_id" "vault" {
  byte_length = 4
}

resource "google_service_account" "main" {
  account_id   = "${var.resource_name_prefix}-vault-${random_id.vault.hex}"
  display_name = "Vault KMS and auto-join for auto-unseal"
}

resource "google_project_iam_custom_role" "autojoin_role" {
  role_id     = "vaultAutojoin${random_id.vault.hex}"
  title       = "vault-auto-join-${random_id.vault.hex}"
  description = "Custom role for Vault auto-join"
  permissions = [
    "compute.zones.list",
    "compute.instances.list"
  ]
}

resource "google_project_iam_custom_role" "kms_role" {
  role_id     = "vaultKms${random_id.vault.hex}"
  title       = "vault-kms-${random_id.vault.hex}"
  description = "Custom role for Vault KMS binding"
  permissions = [
    "cloudkms.cryptoKeyVersions.useToEncrypt",
    "cloudkms.cryptoKeyVersions.useToDecrypt",
    "cloudkms.cryptoKeys.get",
    "cloudkms.locations.get",
    "cloudkms.locations.list",
    "resourcemanager.projects.get"
  ]
}

resource "google_kms_key_ring_iam_binding" "vault_iam_kms_binding" {
  key_ring_id = var.key_ring_id
  role        = google_project_iam_custom_role.kms_role.name

  members = ["serviceAccount:${google_service_account.main.email}"]
}

resource "google_project_iam_member" "vault_auto_join" {
  project = var.project_id
  member  = "serviceAccount:${google_service_account.main.email}"
  role    = google_project_iam_custom_role.autojoin_role.name
}

resource "google_secret_manager_secret_iam_member" "secret_manager_member" {
  secret_id = var.tls_secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.main.email}"
}
