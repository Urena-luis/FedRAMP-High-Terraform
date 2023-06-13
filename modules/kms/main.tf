locals {
  keys_by_name = zipmap(var.keys, var.prevent_destroy ? slice(google_kms_crypto_key.key[*].id, 0, length(var.keys)) : slice(google_kms_crypto_key.key_ephemeral[*].id, 0, length(var.keys)))
}

data "google_kms_key_ring" "existing_key_ring" {
  count = var.use_existing_keyring ? 1 : 0
  name  = var.keyring
  #project = var.project_id
  project  = var.cmek_project_id
  location = var.location
}

resource "google_kms_key_ring" "key_ring" {
  count = var.use_existing_keyring ? 0 : 1
  name  = var.keyring
  #project = var.project_id
  project  = var.cmek_project_id
  location = var.location
}

resource "random_string" "crypto_key_sufix" {
  length    = 8
  min_lower = 8
}

resource "google_kms_crypto_key" "key" {
  count           = var.prevent_destroy ? length(var.keys) : 0
  name            = "${var.keys[count.index]}-${random_string.crypto_key_sufix.result}"
  key_ring        = var.use_existing_keyring ? data.google_kms_key_ring.existing_key_ring[0].id : google_kms_key_ring.key_ring[0].id
  rotation_period = var.key_rotation_period
  depends_on      = [google_kms_key_ring.key_ring]

  lifecycle {
    prevent_destroy = false
  }

  version_template {
    algorithm        = var.key_algorithm
    protection_level = var.key_protection_level
  }

  labels = var.labels
}

resource "google_kms_crypto_key" "key_ephemeral" {
  count           = var.prevent_destroy ? 0 : length(var.keys)
  name            = "${var.keys[count.index]}-${random_string.crypto_key_sufix.result}"
  key_ring        = var.use_existing_keyring ? data.google_kms_key_ring.existing_key_ring[0].id : google_kms_key_ring.key_ring[0].id
  rotation_period = var.key_rotation_period

  lifecycle {
    prevent_destroy = false
  }

  version_template {
    algorithm        = var.key_algorithm
    protection_level = var.key_protection_level
  }

  labels = var.labels
}

resource "google_kms_crypto_key_iam_binding" "owners" {
  for_each      = toset(var.set_owners_for)
  role          = "roles/owner"
  crypto_key_id = local.keys_by_name[each.value]
  members       = var.owners
}

resource "google_kms_crypto_key_iam_binding" "decrypters" {
  for_each      = toset(var.set_decrypters_for)
  role          = "roles/cloudkms.cryptoKeyDecrypter"
  crypto_key_id = local.keys_by_name[each.value]
  members       = var.decrypters
}

resource "google_kms_crypto_key_iam_binding" "encrypters" {
  for_each      = toset(var.set_encrypters_for)
  role          = "roles/cloudkms.cryptoKeyEncrypter"
  crypto_key_id = local.keys_by_name[each.value]
  members       = var.encrypters
}
