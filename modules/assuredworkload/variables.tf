variable "billing_account" {
  description = "Billing account details"
  type        = string
}

variable "compliance_regime" {
  description = "compliance regime type"
  type        = string
}

variable "assured_workload_name" {
  description = "Name of the assured workloads . Folder is created with the same name"
  type        = string
}

variable "location" {
  description = "location of assured workloads"
  type        = string
}

variable "organization_id" {
  description = "Organization id"
  type        = string
}

variable "next_rotation_time" {
  description = "cmek key roation time"
  type        = string
}

variable "rotation_period" {
  description = "key roation period"
  type        = string
}

variable "assured_workloads_labels" {
  description = "Labels applied to the workload"
  type        = map(string)
}

variable "parent_resource" {
  description = "choose the parent resource where you want to create the assured workload folderyes"
  type        = string
}

variable "project_number" {
  description = "assured workloads project number "
  type        = string
}

variable "cmek_project_id" {
  description = "assured workloads cmek project id"
  type        = string
}
