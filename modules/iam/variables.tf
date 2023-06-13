variable "organization" {
  description = "Provide the assured workloads Organization"
  type        = string
}

# variable "workloadfolder" {
#   description = "Provide the assured workloads folder"
#   type        = string
# }

variable "workload_project" {
  description = "Provide the assured workloads project id"
  type        = string
}

variable "super_admin_group_email" {
  description = "Provide the superadmin group email"
  type        = string
}

variable "admin_group_email" {
  description = "Provide the admin group email"
  type        = string
}

variable "modeladmin_group_email" {
  description = "Provide the modeladmin group email"
  type        = string
}

variable "dataadmin_group_email" {
  description = "Provide the dataadmin group email"
  type        = string
}

variable "networksecadmin_group_email" {
  description = "Provide the netwok and security admin group email"
  type        = string
}
