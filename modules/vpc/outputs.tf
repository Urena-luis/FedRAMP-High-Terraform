# # hpc vpc

output "ms_vpc_name" {
  value       = module.ms-vpc-module.network_name
  description = "The name of the VPC hpc-vpc"
}

output "ms_vpc_self_link" {
  value       = module.ms-vpc-module.network_self_link
  description = "The URI of the hpc-vpc"
}

output "ms_vpc_subnets" {
  value       = module.ms-vpc-module.subnets_names
  description = "The names of the subnets being created on hpc-vpc"
}

output "ms_vpc_subnets_self_links" {
  value       = module.ms-vpc-module.subnets_self_links
  description = "The self-links of subnets being created"
}

output "subnets_secondary_ranges" {
  value       = flatten(module.ms-vpc-module.subnets_secondary_ranges)
  description = "The secondary ranges associated with these subnets"
}




output "dl_vpc_name" {
  value       = module.dl-vpc-module.network_name
  description = "The name of the VPC dl-vpc"
}

output "dl_vpc_self_link" {
  value       = module.dl-vpc-module.network_self_link
  description = "The URI of the dl-vpc"
}

output "dl_vpc_subnets" {
  value       = module.dl-vpc-module.subnets_names
  description = "The names of the subnets being created on dl-vpc"
}

output "dl_vpc_subnets_self_links" {
  value       = module.dl-vpc-module.subnets_self_links
  description = "The self-links of subnets being created"
}
