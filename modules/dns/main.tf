resource "google_dns_managed_zone" "private-zone" {
  name       = var.name
  project    = var.project_id
  dns_name   = var.dns_name
  labels     = var.labels
  visibility = var.visibility
  private_visibility_config {
    networks {
      network_url = var.network_url
    }
  }
}