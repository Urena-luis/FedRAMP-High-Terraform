variable "project_id" {
  description = "Project id where the dataset and table are created."
  type        = string
}

variable "dataset_name" {
  description = "The dataset name."
  type        = string
}

variable "owner_email" {
  description = "Big query owner email"
  type        = string
}

variable "domain_name" {
  description = "Domain to give read access to."
  type        = string
}

variable "bq_dataset_prefix" {
  description = "Prefix for dataset id."
  type        = string
}

variable "location" {
  description = "Case-Sensitive Location for Big Query dataset (Should be same region as the KMS Keyring)"
  type        = string
}

variable "description" {
  description = "Description about the dataset"
  type        = string
}

variable "labels" {
  description = "Labels provided as a map"
  type        = map(string)
}

variable "delete_contents_on_destroy" {
  description = "If set to true, delete all the tables in the dataset when destroying the resource; otherwise, destroying the resource will fail if tables are present."
  type        = bool
  default     = true
}

variable "deletion_protection" {
  description = "Whether or not to allow Terraform to destroy the instance. Unless this field is set to false in Terraform state, a terraform destroy or terraform apply that would delete the instance will fail"
  type        = bool
  default     = false
}

variable "tables" {
  description = "A list of objects which include table_id, schema, clustering, time_partitioning, range_partitioning, expiration_time and labels."
  default     = []
  type = list(object({
    table_id   = string,
    schema     = string,
    clustering = list(string),
    time_partitioning = object({
      expiration_ms            = string,
      field                    = string,
      type                     = string,
      require_partition_filter = bool,
    }),
    range_partitioning = object({
      field = string,
      range = object({
        start    = string,
        end      = string,
        interval = string,
      }),
    }),
    expiration_time = string,
    labels          = map(string),
  }))
}

#################################
# KMS Variables
################################

variable "create_key" {
  description = "If you want to use an create a key"
  type        = bool
  default     = false
}

variable "enable_cmek" {
  description = "Enable Customer Managed Encryption Key"
  type        = bool
  default     = true
}

variable "use_existing_keyring" {
  description = "If you want to use an existing keyring and don't create a new one -> true"
  type        = bool
  default     = false
}

variable "keyring_name" {
  description = "Name to be used for KMS Keyring"
  type        = string
}

variable "key_name" {
  description = "Name to be used for key"
  type        = string
}

variable "key_rotation_period" {
  description = "Rotation period in seconds to be used for KMS Key"
  type        = string
  default     = "7776000s"
}

variable "prevent_destroy" {
  description = "Prevent bucket key destroy on KMS"
  type        = bool
  default     = true
}

variable "cmek_project_id" {
  description = "assured workloads cmek project id"
  type        = string
}
