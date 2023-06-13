variable "project_id" {
  description = "Projecte ID of the IAM "
  type        = string
}

variable "dataflow_temporary_gcs_bucket" {
  description = "dataflow temp bucket used for Dataflow job"
  type        = string
}

variable "give_access_to_bigquery" {
  description = "Boolean to verify if bigquery access is needed to dataflow"
  type        = bool
}

variable "give_access_to_storage" {
  description = "Boolean to verify if cloud storage access is needed to dataflow"
  type        = string
}

variable "give_access_to_pubsub" {
  description = "Boolean to verify if pubsub access is needed to dataflow"
  type        = string
}

variable "dataset_id" {
  description = "dataset ID to which access is provided"
  type        = string
}

variable "bucket_name" {
  description = "Bucket name to which access is provided"
  type        = string
}

variable "subscription_name" {
  description = "Subscription name to which access is provided"
  type        = string
}

variable "dataflow_worker_service_account" {
  description = "dataflow worker servide account"
  type        = string
}
