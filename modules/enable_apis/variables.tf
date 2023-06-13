variable "project_id" {
  description = "The project id for the environment to deploy in"
  type        = string
}

variable "gcp_service_list" {
  description = "List of apis necessary for the project"
  type        = list(string)
  default = [
    "assuredworkloads.googleapis.com",
    "cloudbilling.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
    "compute.googleapis.com",
    "storage-component.googleapis.com",
    "storage-api.googleapis.com",
    "orgpolicy.googleapis.com",
    "serviceusage.googleapis.com",
    "dns.googleapis.com",
    "cloudkms.googleapis.com",
    "domains.googleapis.com",
    "iamcredentials.googleapis.com",
    "container.googleapis.com",
    "containerregistry.googleapis.com",
    "bigquery.googleapis.com",
    "dataflow.googleapis.com"
  ]
}
