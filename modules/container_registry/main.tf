resource "google_artifact_registry_repository" "ml-repo-docker" {
  project       = var.project_id
  location      = var.location
  repository_id = "ml-registry"
  description   = "Docker repository for ML"
  format        = "DOCKER"
}
