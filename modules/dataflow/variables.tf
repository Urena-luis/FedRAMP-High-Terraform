variable "project_id" {
  description = "Project ID of the assured workload in which the dataflow pipeline will be deployed"
  type        = string
}

variable "dataflow_job_name" {
  description = "Dataflow job name"
  type        = string
}


variable "dataflow_template_gcs_path" {
  description = "GCS bucket where Dataflow pipeline template is stored"
  type        = string
}
variable "dataflow_temporary_gcs_bucket" {
  description = "Temporary GCS bucket for dataflow temp files"
  type        = string
}
variable "enable_streamin_engine" {
  description = "Enable/disable the use of Streaming Engine for the job"
  type        = bool
}
variable "parameters" {
  description = "Dataflow pipeline template parameters. This will be different based on the chosen template"
  type        = map(string)
}
variable "dataflow_max_workers" {
  description = "Number of dataflow workers should run parallelly"
  type        = number
}
variable "dataflow_network" {
  description = "Network in which dataflow worker VMs should be deployed"
  type        = string
}
variable "dataflow_subnetwork" {
  description = "Subnetwork in which dataflow worker VMs should be deployed"
  type        = string
}
variable "location" {
  description = "Google cloud Region"
  type        = string
}

variable "use_existing_keyring" {
  description = "If you want to use an existing keyring and don't create a new one -> true"
  type        = bool
}

variable "key_name" {
  description = "Name to be used for KMS Key for CMEK"
  type        = string
}

variable "keyring_name" {
  description = "Name to be used for KMS Keyring for CMEK.  set (use_existing_keyring) to false if using this varaible"
  type        = string
}

variable "key_rotation_period" {
  description = "Rotation period in seconds to be used for KMS Key"
  type        = string
}


variable "service_account_email" {
  description = "Service account for Dataflow workers nodes"
  type        = string
}

variable "cmek_project_id" {
  description = "assured workloads cmek project id"
  type        = string
}
