resource "random_id" "sa_sufix" {
  byte_length = 8
}

data "google_service_account" "existing_account" {
  count      = var.compute_service_account == "" ? 0 : 1
  account_id = var.compute_service_account
  project    = var.project_id
}

module "vm_service_account" {
  count                      = var.compute_service_account == "" ? 1 : 0
  source                     = "../service_account"
  account_id                 = "sa-${var.sa_prefix}-${random_id.sa_sufix.dec}"
  display_name               = "vm_service_account"
  description                = "Create a new service account per VM"
  project_id                 = var.project_id
  service_account_roles_list = []
  create_sa_key              = false
}

data "google_project" "compute_project" {
  project_id = var.project_id
}

module "kms" {
  count  = var.create_key ? 1 : 0
  source = "../kms/"
  #project_id           = var.project_id 
  cmek_project_id      = var.cmek_project_id
  use_existing_keyring = var.use_existing_keyring
  keyring              = var.keyring_name
  location             = var.region
  keys                 = [var.key_name]
  key_rotation_period  = var.key_rotation_period
  encrypters           = ["serviceAccount:service-${data.google_project.compute_project.number}@compute-system.iam.gserviceaccount.com"]
  set_encrypters_for   = [var.key_name]
  decrypters           = ["serviceAccount:service-${data.google_project.compute_project.number}@compute-system.iam.gserviceaccount.com"]
  set_decrypters_for   = [var.key_name]
  prevent_destroy      = var.prevent_destroy
}

resource "google_kms_crypto_key_iam_binding" "crypto_key" {
  count         = var.create_key ? 0 : 1
  crypto_key_id = var.disk_encryption_key
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  members       = ["serviceAccount:service-${data.google_project.compute_project.number}@compute-system.iam.gserviceaccount.com"]
}

module "instance_template" {
  source      = "github.com/terraform-google-modules/terraform-google-vm/modules/instance_template"
  project_id  = var.project_id
  name_prefix = var.instance_prefix
  region      = var.region
  service_account = var.compute_service_account == "" ? ({
    email  = module.vm_service_account[0].email
    scopes = ["cloud-platform"]
    }) : ({
    email  = data.google_service_account.existing_account[0].email
    scopes = ["cloud-platform"]
  })
  can_ip_forward      = var.can_ip_forward
  disk_encryption_key = var.create_key ? module.kms[0].keys[var.key_name] : var.disk_encryption_key
  disk_size_gb        = var.disk_size_gb
  disk_type           = var.disk_type
  enable_shielded_vm  = true
  shielded_instance_config = ({
    enable_secure_boot          = true
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  })
  machine_type         = var.machine_type
  source_image         = var.source_image
  source_image_project = var.source_image_project
  source_image_family  = var.source_image_family
  startup_script       = var.startup_script

  metadata = var.metadata
  labels   = var.labels
  additional_disks = [({
    disk_name    = null
    device_name  = "${var.instance_prefix}-device"
    auto_delete  = true
    boot         = false
    disk_size_gb = tonumber(var.disk_size_gb)
    disk_type    = var.disk_type
    disk_labels  = var.labels
  })]
  tags               = var.tags
  network            = var.network
  subnetwork         = var.subnetwork
  subnetwork_project = var.project_id
}

//autoscaling policy
resource "google_compute_autoscaler" "deep_learning_scale" {
  provider = google-beta
  project  = var.project_id
  name     = var.autoscaling_name
  zone     = var.zone
  target   = google_compute_instance_group_manager.dl.id

  autoscaling_policy {
    max_replicas = var.max_replicas
    min_replicas = var.min_replicas
  }
}
resource "google_compute_target_pool" "default" {
  provider = google-beta
  project  = var.project_id
  region   = var.region
  name     = "target-pool-sample"
}

//instance group 
resource "google_compute_instance_group_manager" "dl" {
  provider   = google-beta
  project    = var.project_id
  depends_on = [module.instance_template]
  name       = var.instance_group_name
  zone       = var.zone
  version {
    instance_template = module.instance_template.self_link
    name              = "primary"
  }

  target_pools       = [google_compute_target_pool.default.id]
  base_instance_name = var.instance_name

}
