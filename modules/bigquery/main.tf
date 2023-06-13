locals {
  dataset_id = "${var.bq_dataset_prefix}_${lower(var.dataset_name)}bq${random_string.bq_suffix.result}"
}

data "google_project" "project" {
  project_id = var.project_id
}

resource "random_string" "bq_suffix" {
  length  = 5
  upper   = false
  numeric = true
  lower   = true
  special = false
}

data "google_project" "compute_project" {
  project_id = var.project_id
}

# resource "google_bigquery_dataset_access" "dataset_owner" {
#   depends_on    = [module.bigquery, module.kms]
#   project       = var.project_id
#   dataset_id    = local.dataset_id
#   role          = "roles/bigquery.dataOwner"
#   user_by_email = var.owner_email
# }

# resource "google_bigquery_dataset_access" "dataset_readers" {
#   depends_on = [module.bigquery, module.kms]
#   project    = var.project_id
#   dataset_id = local.dataset_id
#   role       = "roles/bigquery.dataViewer"
#   domain     = var.domain_name
# }


module "kms" {
  count  = var.create_key ? 1 : 0
  source = "../kms/"
  #project_id           = var.project_id
  cmek_project_id      = var.cmek_project_id
  use_existing_keyring = var.use_existing_keyring
  keyring              = var.keyring_name
  location             = var.location
  keys                 = [var.key_name]
  key_rotation_period  = var.key_rotation_period
  encrypters           = ["serviceAccount:service-${data.google_project.compute_project.number}@compute-system.iam.gserviceaccount.com"]
  set_encrypters_for   = [var.key_name]
  decrypters           = ["serviceAccount:service-${data.google_project.compute_project.number}@compute-system.iam.gserviceaccount.com"]
  set_decrypters_for   = [var.key_name]
  prevent_destroy      = var.prevent_destroy
}


module "bigquery" {
  depends_on                 = [module.kms]
  source                     = "terraform-google-modules/bigquery/google"
  version                    = "~> 5.2"
  dataset_id                 = local.dataset_id
  dataset_name               = local.dataset_id
  description                = var.description
  project_id                 = var.project_id
  location                   = var.location
  delete_contents_on_destroy = var.delete_contents_on_destroy
  deletion_protection        = var.deletion_protection
  dataset_labels             = var.labels
  tables                     = var.tables
  access = [
    {
      "role" : "roles/bigquery.dataOwner",
      "group_by_email" : var.owner_email
    },
    {
      "role" : "roles/bigquery.dataViewer",
      "domain" : var.domain_name
    }
  ]
}


