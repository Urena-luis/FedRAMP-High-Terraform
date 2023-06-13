variable "project_id" {
  type        = string
  description = "The project ID to host the cluster in (required)"
}

variable "network" {
  type        = string
  description = "The VPC network name."
}

variable "network_project_id" {
  type        = string
  description = "The VPC network project id."
}

variable "compute_engine_service_account" {
  type        = string
  description = "The service account email"
}

variable "master_authorized_networks" {
  type        = list(map(string))
  description = "Define CIDR for authorized networks"
  default     = []
}

variable "gke_settings" {
  type = map(object({
    name                      = string
    subnetwork                = string
    ip_range_pods             = string
    ip_range_services         = string
    master_ipv4_cidr_block    = string
    enable_external_ip        = bool
    default_max_pods_per_node = number
    region                    = string
    node_locations            = string
    node_pool_min_count       = number
    node_pool_max_count       = number
    machine_type              = string
    master_authorized_networks = list(object({
      cidr_block   = string
      display_name = string
    }))
  }))
  default     = {}
  description = "Map of all the clusters configurations"
}


variable "use_existing_keyring" {
  description = "If you want to use an existing keyring and don't create a new one -> true"
  type        = bool
}

variable "key_name" {
  description = "Name to be used for KMS Key for CMEK"
  type        = string
}

variable "keyring_name" {
  description = "Name to be used for KMS Keyring for CMEK"
  type        = string
}

variable "key_rotation_period" {
  description = "Rotation period in seconds to be used for KMS Key"
  type        = string
}

variable "prevent_destroy" {
  type        = string
  description = "Prevent bucket key destroy on KMS"
}

variable "labels" {
  type        = map(string)
  description = "Define labels"
}

variable "region" {
  type        = string
  description = "location of the GKE"
}

variable "cmek_project_id" {
  description = "assured workloads cmek project id"
  type        = string
}


# Optional Variables

# variable "enforce_bin_auth_policy" {
#   type        = bool
#   description = "Enable or Disable creation of binary authorization policy."
#   default     = false
# }

# variable "bin_auth_attestor_names" {
#   type        = list(string)
#   description = "Binary Authorization Attestor Names set up in shared app_cicd project."
# }

# variable "attestors_keyring_id" {
#   type        = string
#   description = "The attestors keyring id"
# }

# variable "allowlist_patterns" {
#   type        = list(string)
#   description = "The google binary authorization policy allowlist patterns"
#   default     = ["gcr.io/config-management-release/*"]
# }
