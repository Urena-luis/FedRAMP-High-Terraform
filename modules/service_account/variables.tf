variable "project_id" {
  type        = string
  description = "The ID of the project in which the service account will be created."
}

variable "account_id" {
  type        = string
  description = "The service account id."
}

variable "display_name" {
  type        = string
  description = "The service account display name."
  default     = ""
}

variable "description" {
  type        = string
  description = "The service account description."
  default     = ""
}

variable "create_sa_key" {
  type        = bool
  description = "Set to true if a user managed key should be created for the service account"
  default     = false
}

variable "service_account_roles_list" {
  description = "List of apis necessary for the project"
  type        = list(string)
}
