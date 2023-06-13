# SuperAdmin groups will have admin level access at the assuredworkloads organization level

module "superadmingroup" {
  source        = "terraform-google-modules/iam/google//modules/organizations_iam"
  organizations = [var.organization]
  mode          = "additive"
  bindings = {
    "roles/resourcemanager.organizationAdmin" = [
      "group:${var.super_admin_group_email}",
    ]
    "roles/orgpolicy.policyAdmin" = [
      "group:${var.super_admin_group_email}",
    ]
    "roles/billing.admin" = [
      "group:${var.super_admin_group_email}",
    ]
    "roles/billing.creator" = [
      "group:${var.super_admin_group_email}",
    ]
    "roles/assuredworkloads.admin" = [
      "group:${var.super_admin_group_email}",
    ]
    "roles/owner" = [
      "group:${var.super_admin_group_email}",
    ]
  }
}

# Admin groups will have admin level access who can able to deploy all the terraform resources

module "admingroup" {
  source        = "terraform-google-modules/iam/google//modules/organizations_iam"
  organizations = [var.organization]
  mode          = "additive"
  bindings = {
    "roles/resourcemanager.organizationAdmin" = [
      "group:${var.admin_group_email}",
    ]
    "roles/billing.admin" = [
      "group:${var.admin_group_email}",
    ]
    "roles/assuredworkloads.admin" = [
      "group:${var.admin_group_email}",
    ]
    "roles/owner" = [
      "group:${var.admin_group_email}",
    ]
  }
}

# Model Admin groups will have acess to develop the the ML models at project level

module "modeladmingroup" {
  source   = "terraform-google-modules/iam/google//modules/projects_iam"
  projects = [var.workload_project]
  mode     = "additive"

  bindings = {
    "roles/container.developer" = [
      "group:${var.modeladmin_group_email}"
    ]
    "roles/iam.serviceAccountUser" = [
      "group:${var.modeladmin_group_email}"
    ]
    "roles/bigquery.dataViewer" = [
      "group:${var.modeladmin_group_email}"
    ]
    "roles/compute.instanceAdmin.v1" = [
      "group:${var.modeladmin_group_email}"
    ]
    "roles/compute.osLogin" = [
      "group:${var.modeladmin_group_email}"
    ]
    "roles/compute.loadBalancerServiceUser" = [
      "group:${var.modeladmin_group_email}"
    ]
  }
}

#Data Admin Groups will have access to the bigquery resources at the project level

module "dataadmingroup" {
  source   = "terraform-google-modules/iam/google//modules/projects_iam"
  projects = [var.workload_project]
  mode     = "additive"

  bindings = {
    "roles/bigquery.admin" = [
      "group:${var.dataadmin_group_email}",
    ]
  }
}

#Network and security admin groupps will have access to the networking and security services at teh project level

module "networksecurityadmingroup" {
  source   = "terraform-google-modules/iam/google//modules/projects_iam"
  projects = [var.workload_project]
  mode     = "additive"

  bindings = {
    "roles/compute.networkAdmin" = [
      "group:${var.networksecadmin_group_email}",
    ]
    "roles/compute.securityAdmin" = [
      "group:${var.networksecadmin_group_email}",
    ]
  }
}
