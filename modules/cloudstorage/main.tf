# This module will create the GCS buckets with lifecycle rules, storage class and will enable CMEK feature of KMS for buckets
module "gcs_buckets" {
  source               = "terraform-google-modules/cloud-storage/google"
  version              = "~> 3.2"
  project_id           = var.project_id
  names                = var.names
  prefix               = var.prefix
  location             = var.bucket_location
  storage_class        = var.storage_class
  labels               = var.labels
  lifecycle_rules      = var.lifecycle_rules
  force_destroy        = { for name in var.names : name => true }
  versioning           = { for name in var.names : name => var.versioning }
  bucket_policy_only   = { for name in var.names : name => true }
  depends_on           = [module.kms]
  encryption_key_names = var.enable_cmek ? { for name in var.names : name => module.kms[0].keys["${name}-key"] } : {}
}

# This block updates the IAM policy to grant a role of storage admin to a group with selected members to ensure that default "allUsers" won't have access to the buckets
resource "google_storage_bucket_iam_member" "gcs_admin_group" {
  for_each = var.gcs_admin_group_id != "" ? toset(module.gcs_buckets.names_list) : []
  bucket   = each.key
  role     = "roles/storage.admin"
  member   = "group:${var.gcs_admin_group_id}"
}

# This block updates the IAM policy to grant a role of storage object creator to a group with selected members to ensure that default "allUsers" won't have access to the buckets
resource "google_storage_bucket_iam_member" "gcs_write_group" {
  for_each = var.gcs_write_group_id != "" ? toset(module.gcs_buckets.names_list) : []
  bucket   = each.key
  role     = "roles/storage.objectCreator"
  member   = "group:${var.gcs_write_group_id}"
}

# Data block for service account for cloud storage bucket
data "google_storage_project_service_account" "gcs_account" {
  project = var.project_id
}

# This block will be used to enable CMEK and to create keyring, keys for encryption and decryption for cloud storage bucket objects and ensure KMS keys are not deleted and have rotation period
module "kms" {
  count  = var.enable_cmek ? 1 : 0
  source = "../kms/"
  #project_id           = var.project_id
  cmek_project_id      = var.cmek_project_id
  use_existing_keyring = var.use_existing_keyring
  keyring              = var.keyring_name
  location             = var.key_ring_location
  keys                 = [for name in var.names : "${name}-key"]
  key_rotation_period  = var.key_rotation_period
  encrypters           = [for name in var.names : "serviceAccount:${data.google_storage_project_service_account.gcs_account.email_address}"]
  set_encrypters_for   = [for name in var.names : "${name}-key"]
  decrypters           = [for name in var.names : "serviceAccount:${data.google_storage_project_service_account.gcs_account.email_address}"]
  set_decrypters_for   = [for name in var.names : "${name}-key"]
  prevent_destroy      = var.prevent_destroy
}
