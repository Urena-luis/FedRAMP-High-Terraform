resource "google_dataflow_job" "pubsub_stream" {
  name                    = var.dataflow_job_name
  project                 = var.project_id
  template_gcs_path       = var.dataflow_template_gcs_path
  temp_gcs_location       = var.dataflow_temporary_gcs_bucket
  enable_streaming_engine = var.enable_streamin_engine
  parameters              = var.parameters
  # {
  #   inputFilePattern = "${google_storage_bucket.bucket1.url}/*.json"
  #   outputTopic    = google_pubsub_topic.topic.id
  # }
  # transform_name_mapping  = {
  #     name = "test_job"
  #     env = "test"
  # }
  on_delete              = "cancel"
  max_workers            = var.dataflow_max_workers
  network                = var.dataflow_network
  subnetwork             = var.dataflow_subnetwork #"regions/{{.datawarehouse_region}}/subnetworks/{{.datawarehouse_subnet_name}}"
  ip_configuration       = "WORKER_IP_PRIVATE"
  additional_experiments = ["enable_stackdriver_agent_metrics"]
  region                 = var.location
  kms_key_name           = module.kms[0].keys[var.key_name]
  service_account_email  = var.service_account_email
}

#Data block for project id
data "google_project" "compute_project" {
  project_id = var.project_id
}

#This module will be used to create keyring, encryption/decryption keys for compute engine DMZ and ensure that the customer encryption keys will be used for encryption of data stored on Google Compute Engine DMZ disk
module "kms" {
  count  = 1
  source = "../kms/"
  #project_id           = var.project_id
  cmek_project_id      = var.cmek_project_id
  use_existing_keyring = var.use_existing_keyring
  keyring              = var.keyring_name
  location             = var.location
  keys                 = [var.key_name]
  key_rotation_period  = var.key_rotation_period
  encrypters           = ["serviceAccount:service-${data.google_project.compute_project.number}@dataflow-service-producer-prod.iam.gserviceaccount.com"]
  set_encrypters_for   = [var.key_name]
  decrypters           = ["serviceAccount:service-${data.google_project.compute_project.number}@dataflow-service-producer-prod.iam.gserviceaccount.com"]
  set_decrypters_for   = [var.key_name]
}

#This will create IAM role binding and give encrypter/decrypter role to the compute engine DMZ service account to encrypt/decrypt Google Compute Engine DMZ disk
resource "google_kms_crypto_key_iam_binding" "crypto_key" {
  count         = 1
  crypto_key_id = module.kms[0].keys[var.key_name] #var.disk_encryption_key
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  members = [
    "serviceAccount:service-${data.google_project.compute_project.number}@dataflow-service-producer-prod.iam.gserviceaccount.com",
    "serviceAccount:${var.service_account_email}",
    "serviceAccount:service-${data.google_project.compute_project.number}@compute-system.iam.gserviceaccount.com"
  ]
}

# Access to dataflow service agent
resource "google_project_iam_binding" "service_agent_access" {
  project = var.project_id
  role    = "roles/dataflow.serviceAgent"
  members = [
    "serviceAccount:service-${data.google_project.compute_project.number}@dataflow-service-producer-prod.iam.gserviceaccount.com",
  ]
}
