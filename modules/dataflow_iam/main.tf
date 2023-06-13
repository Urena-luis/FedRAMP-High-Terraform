# Data block for service account for cloud storage bucket
data "google_project" "compute_project" {
  project_id = var.project_id
}

# Access to dataflow Temp bucket
resource "google_storage_bucket_iam_binding" "dataflow_access_to_temp_bucket" {
  bucket = var.dataflow_temporary_gcs_bucket
  role   = "roles/storage.objectAdmin"
  members = [
    "serviceAccount:${var.dataflow_worker_service_account}",
    "serviceAccount:service-${data.google_project.compute_project.number}@dataflow-service-producer-prod.iam.gserviceaccount.com",
  ]
}

# Access to BigQuery 

resource "google_bigquery_dataset_iam_binding" "dataflow_access_to_bigquery" {
  project    = var.project_id
  count      = var.give_access_to_bigquery ? 1 : 0
  dataset_id = var.dataset_id
  role       = "roles/bigquery.dataEditor"
  members = [
    "serviceAccount:${var.dataflow_worker_service_account}",
    "serviceAccount:service-${data.google_project.compute_project.number}@dataflow-service-producer-prod.iam.gserviceaccount.com",
  ]

}

# Access to Storage
resource "google_storage_bucket_iam_binding" "dataflow_access_to_storage" {
  count  = var.give_access_to_storage ? 1 : 0
  bucket = var.bucket_name
  role   = "roles/storage.objectAdmin"
  members = [
    "serviceAccount:${var.dataflow_worker_service_account}",
    "serviceAccount:service-${data.google_project.compute_project.number}@dataflow-service-producer-prod.iam.gserviceaccount.com",
  ]
}

# Access to pubsub
resource "google_pubsub_subscription_iam_binding" "dataflow_access_to_pubsubviewer" {
  project      = var.project_id
  count        = var.give_access_to_pubsub ? 1 : 0
  subscription = var.subscription_name
  role         = "roles/pubsub.viewer"
  members = [
    "serviceAccount:${var.dataflow_worker_service_account}",
    "serviceAccount:service-${data.google_project.compute_project.number}@dataflow-service-producer-prod.iam.gserviceaccount.com",
  ]
}


resource "google_pubsub_subscription_iam_binding" "dataflow_access_to_pubsubsubscriber" {
  project      = var.project_id
  count        = var.give_access_to_pubsub ? 1 : 0
  subscription = var.subscription_name
  role         = "roles/pubsub.subscriber"
  members = [
    "serviceAccount:${var.dataflow_worker_service_account}",
    "serviceAccount:service-${data.google_project.compute_project.number}@dataflow-service-producer-prod.iam.gserviceaccount.com",
  ]
}

# Access to workers
resource "google_project_iam_binding" "data_flow_service_account_access_worker" {
  project = var.project_id
  role    = "roles/dataflow.worker"
  members = [
    "serviceAccount:${var.dataflow_worker_service_account}",
    "serviceAccount:service-${data.google_project.compute_project.number}@dataflow-service-producer-prod.iam.gserviceaccount.com",
  ]
}

