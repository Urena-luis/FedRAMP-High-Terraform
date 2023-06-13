resource "google_assured_workloads_workload" "primary" {
  billing_account   = var.billing_account
  compliance_regime = var.compliance_regime
  display_name      = var.assured_workload_name
  location          = var.location
  organization      = var.organization_id

  kms_settings {
    next_rotation_time = var.next_rotation_time
    rotation_period    = var.rotation_period
  }

  labels = var.assured_workloads_labels

  provisioned_resources_parent = var.parent_resource

  resource_settings {
    resource_id   = var.project_number
    resource_type = "CONSUMER_PROJECT"
  }

  resource_settings {
    resource_id   = var.cmek_project_id
    resource_type = "ENCRYPTION_KEYS_PROJECT"
  }

  #   resource_settings {
  #     resource_id   = "ring"
  #     resource_type = "KEYRING"
  #   }
}
