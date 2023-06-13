// ****** Model Serving VPC Module ******

module "ms-vpc-module" {
  source                                 = "github.com/terraform-google-modules/terraform-google-network?ref=v5.2.0"
  project_id                             = var.project_id
  network_name                           = var.ms_vpc_name
  delete_default_internet_gateway_routes = false
  subnets                                = var.ms-subnets
  firewall_rules                         = var.ms-firewall-rules
  secondary_ranges = {
    (var.ms-subnets[0].subnet_name) = [
      {
        range_name    = "${var.ms-subnets[0].subnet_name}-pods"
        ip_cidr_range = var.secondary_pods_subnet_range
      },
      {
        range_name    = "${var.ms-subnets[0].subnet_name}-services"
        ip_cidr_range = var.secondary_services_subnet_range
      },
    ]

  }
}


// ****** Deep Learning VPC Module ******

module "dl-vpc-module" {
  source                                 = "github.com/terraform-google-modules/terraform-google-network?ref=v5.2.0"
  project_id                             = var.project_id
  network_name                           = var.dl_vpc_name
  delete_default_internet_gateway_routes = false
  subnets                                = var.dl-subnets
  firewall_rules                         = var.dl-firewall-rules
}

// dataflow vpc

module "data-flow-vpc" {
  source                                 = "github.com/terraform-google-modules/terraform-google-network?ref=v5.2.0"
  project_id                             = var.project_id
  network_name                           = var.df_network_name
  delete_default_internet_gateway_routes = false
  subnets                                = var.df_subnets
  firewall_rules                         = var.df_firewall_rules
}