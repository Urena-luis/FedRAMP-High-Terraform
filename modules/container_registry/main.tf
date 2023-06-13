resource "google_container_registry" "ml-registry" {
  project  = var.project_id
  location = var.location
}