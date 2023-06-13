variable "project_id" {
  description = "Project id where the DNS Zone is created."
  type        = string
}

variable "name" {
  type        = string
  description = "Display name of DNS Zone"
}

// You need to add a period at the end of the domain name 
variable "dns_name" {
  type        = string
  description = "Domain name you own. ex: abc.com."
}

variable "labels" {
  type        = any
  description = "labels"
}

variable "visibility" {
  type        = string
  description = "Setting for public or private dns zone"
  default     = "private"
}
//format for network url is projects/project_name/global/networks/network_name
variable "network_url" {
  type        = string
  description = "VPC/networks where the private dns is visible from"
}