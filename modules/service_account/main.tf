resource "google_service_account" "service_account" {
  account_id   = var.account_id
  project      = var.project_id
  display_name = var.display_name
  description  = var.description
}

resource "google_service_account_key" "service_account_key" {
  count              = var.create_sa_key ? 1 : 0
  service_account_id = google_service_account.service_account.name
}

resource "google_project_iam_binding" "project" {
  project  = var.project_id
  for_each = toset(var.service_account_roles_list)
  role     = each.key

  members = [
    "serviceAccount:${google_service_account.service_account.email}",
  ]
}