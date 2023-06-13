variable "project_id" {
  description = "The project ID to deploy to"
  type        = string
}

variable "network" {
  description = "The VPC network self link"
  type        = string
}

variable "router_name" {
  description = "Name of the router"
  type        = string
}

variable "router_region" {
  description = "Name of the router region"
  type        = string
}

variable "nat_name" {
  description = "Name of the name"
  type        = string
}
