#This block will be used to list all API services needs to be enabled to run all the modules here. See variables.tf file for number of services used in the project.
resource "google_project_service" "gcp_services" {
  for_each                   = toset(var.gcp_service_list)
  project                    = var.project_id
  service                    = each.key
  disable_dependent_services = true
  disable_on_destroy         = false
}
