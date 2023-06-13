variable "project_id" {
  description = "The project ID to host the network in"
  type        = string
}


variable "ms_vpc_name" {
  description = "The name of the model serving VPC network being created"
  type        = string
}

variable "dl_vpc_name" {
  description = "The name of the dep learning VPC network being created"
  type        = string
}


variable "ms-subnets" {
  type        = list(map(string))
  description = "The list of subnets being created"
}

variable "dl-subnets" {
  type        = list(map(string))
  description = "The list of subnets being created"
}



/*
variable "firewall-rules" {
  type        = any
  description = "Firewall rules to configure for hpc cluster vpc network "
  default     = [{
    name = "allow-ingress-from-iap"
    direction = "INGRESS"
    ranges = ["35.235.240.0/20"]
    allow = [{
      protocol = "tcp"
      ports = ["22","3389"]
    }]
    deny = []
    log_config = {
      metadata = "INCLUDE_ALL_METADATA"
    }
  }]
}
*/
variable "ms-firewall-rules" {
  type        = any
  description = "Firewall rules to configure for dmz vpc network"
  default     = []
}

variable "dl-firewall-rules" {
  type        = any
  description = "Firewall rules to configure for dmz vpc network"
  default     = []
}


variable "secondary_pods_subnet_range" {
  description = "Secondary IP ranges for GKE Pods"
  type        = string
}

variable "secondary_services_subnet_range" {
  description = "Secondary IP ranges for GKE Services"
  type        = string
}

//data flow vpc variables

variable "df_network_name" {
  description = "The name of the data flow vpc"
  type        = string
}

variable "df_subnets" {
  type        = list(map(string))
  description = "The list of subnets being created"
}

variable "df_firewall_rules" {
  type        = any
  description = "Firewall rules to configure for dataflow network"
  default     = []
}