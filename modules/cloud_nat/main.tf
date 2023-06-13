resource "google_compute_router" "router" {
  project = var.project_id
  name    = var.router_name
  network = var.network
  region  = var.router_region
}

module "cloud-nat" {
  source                             = "terraform-google-modules/cloud-nat/google"
  version                            = "~> 2.0"
  project_id                         = var.project_id
  region                             = var.router_region
  router                             = google_compute_router.router.name
  name                               = var.nat_name
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}