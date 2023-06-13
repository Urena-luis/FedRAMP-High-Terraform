# locals {
#   attestors = [for attestor_name in var.bin_auth_attestor_names : module.attestors[attestor_name].attestor]
# }

data "google_project" "gke_project" {
  project_id = var.project_id
}

module "kms" {
  count  = 1
  source = "../kms/"
  #project_id           = var.project_id
  cmek_project_id      = var.cmek_project_id
  use_existing_keyring = var.use_existing_keyring
  keyring              = var.keyring_name
  location             = var.region #var.key_location
  keys                 = [var.key_name]
  key_rotation_period  = var.key_rotation_period
  encrypters           = ["serviceAccount:service-${data.google_project.gke_project.number}@container-engine-robot.iam.gserviceaccount.com"]
  set_encrypters_for   = [var.key_name]
  decrypters           = ["serviceAccount:service-${data.google_project.gke_project.number}@container-engine-robot.iam.gserviceaccount.com"]
  set_decrypters_for   = [var.key_name]
  prevent_destroy      = var.prevent_destroy
  labels               = var.labels
}

resource "google_kms_crypto_key_iam_binding" "crypto_key" {
  count         = 1
  crypto_key_id = module.kms[0].keys[var.key_name]
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  members       = ["serviceAccount:service-${data.google_project.gke_project.number}@container-engine-robot.iam.gserviceaccount.com"]
}

module "clusters" {
  source   = "terraform-google-modules/kubernetes-engine/google//modules/safer-cluster"
  version  = "~> 16.1.0"
  for_each = var.gke_settings

  project_id                 = var.project_id
  network_project_id         = var.network_project_id
  network                    = var.network
  name                       = each.value.name
  subnetwork                 = each.value.subnetwork
  ip_range_pods              = each.value.ip_range_pods
  ip_range_services          = each.value.ip_range_services
  master_ipv4_cidr_block     = each.value.master_ipv4_cidr_block
  default_max_pods_per_node  = each.value.default_max_pods_per_node
  region                     = each.value.region
  master_authorized_networks = each.value.master_authorized_networks
  database_encryption = [{
    state    = "ENCRYPTED"
    key_name = module.kms[0].keys[var.key_name]
  }]

  cluster_resource_labels = {
    "mesh_id" = "proj-${data.google_project.gke_project.number}"
  }
  node_pools_tags = {
    "np-${each.value.region}" : ["boa-${each.key}-cluster", "allow-google-apis", "egress-internet", "boa-cluster", "allow-lb"]
  }
  node_pools = [
    {
      name               = "np-${each.value.region}",
      node_locations     = each.value.node_locations
      auto_repair        = true,
      auto_upgrade       = true,
      enable_secure_boot = true,
      image_type         = "COS_CONTAINERD",
      machine_type       = each.value.machine_type,
      max_count          = each.value.node_pool_max_count,
      min_count          = each.value.node_pool_min_count,
      node_metadata      = "GKE_METADATA_SERVER"
    }
  ]
  node_pools_oauth_scopes = {
    "all" : [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only"
    ],
    "default-node-pool" : []
  }
  compute_engine_service_account = var.compute_engine_service_account
}

# Optional resources commented below

# module "attestors" {
#   source   = "terraform-google-modules/kubernetes-engine/google//modules/binary-authorization"
#   version  = "~> 14.1"
#   for_each = toset(var.bin_auth_attestor_names)

#   project_id    = var.project_id
#   attestor-name = each.key
#   keyring-id    = var.attestors_keyring_id
# }


# resource "google_binary_authorization_policy" "policy" {
#   project = var.project_id

#   global_policy_evaluation_mode = "ENABLE"
#   default_admission_rule {
#     evaluation_mode         = "REQUIRE_ATTESTATION"
#     enforcement_mode        = var.enforce_bin_auth_policy ? "ENFORCED_BLOCK_AND_AUDIT_LOG" : "DRYRUN_AUDIT_LOG_ONLY"
#     require_attestations_by = local.attestors
#   }
#   dynamic "admission_whitelist_patterns" {
#     for_each = concat(var.allowlist_patterns, ["gcr.io/${var.project_id}/*"])
#     content {
#       name_pattern = join(", ", local.attestors)
#     }
#   }
# }