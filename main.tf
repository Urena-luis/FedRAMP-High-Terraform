
module "assured-workload" {
  source                   = "./modules/assuredworkload"
  billing_account          = var.billing_account
  compliance_regime        = var.compliance_regime
  assured_workload_name    = var.assured_workload_name
  project_number           = var.project_number
  cmek_project_id          = var.cmek_project_id
  location                 = var.location
  organization_id          = var.organization_id
  next_rotation_time       = var.next_rotation_time
  rotation_period          = var.rotation_period
  assured_workloads_labels = var.assured_workloads_labels
  parent_resource          = var.parent_resource
}

module "project_to_move" {
  source          = "./modules/gcloud"
  project_id      = var.project_id
  aw_parent_id    = module.assured-workload.folder_id
  organization_id = var.organization_id
  #depends_on      = [module.assured-workload]
}


module "enable-apis" {
  source     = "./modules/enable_apis"
  project_id = var.project_id
  depends_on = [module.assured-workload]
}


module "iam" {
  source                      = "./modules/iam"
  organization                = var.organization_id
  workload_project            = var.project_id
  super_admin_group_email     = var.super_admin_group_email
  admin_group_email           = var.admin_group_email
  modeladmin_group_email      = var.modeladmin_group_email
  dataadmin_group_email       = var.dataadmin_group_email
  networksecadmin_group_email = var.networksecadmin_group_email
  depends_on                  = [module.enable-apis, module.project_to_move, module.assured-workload]
}

module "vpc-module" {
  source     = "./modules/vpc"
  project_id = var.project_id

  ############  ML Model Serving VPC #############
  ms_vpc_name                     = var.ms_vpc_name
  ms-subnets                      = var.ms-subnets
  ms-firewall-rules               = var.ms-firewall-rules
  secondary_pods_subnet_range     = var.secondary_pods_subnet_range
  secondary_services_subnet_range = var.secondary_services_subnet_range

  ############ Deep Learning VPC Module ############

  dl_vpc_name       = var.dl_vpc_name
  dl-subnets        = var.dl-subnets
  dl-firewall-rules = var.dl-firewall-rules

  ############ Dataflow VPC Module ############

  df_network_name = var.dataflow_network_name
  df_subnets = [
    {
      subnet_name           = var.pubsub-to-bq-subnet_name
      subnet_ip             = var.pubsub-to-bq-subnet_ip
      subnet_region         = var.region
      subnet_private_access = "true"
      subnet_flow_logs      = "true"
    },
  ]
  df_firewall_rules = [
    {
      name        = "dataflow-worker-communication"
      description = "Firewall to allow Dataflow workers to allow traffic between each other"
      direction   = "INGRESS"
      ranges      = [var.pubsub-to-bq-subnet_ip]
      source_tags = null
      allow = [
        {
          protocol = "icmp"
          ports    = null
        },
        {
          protocol = "tcp"
          ports    = ["12345-12346"]
        }
      ]
      log_config = {
        metadata = "INCLUDE_ALL_METADATA"
      }
  }]
  depends_on = [module.enable-apis, module.assured-workload]
}

# module "ms_nat_gateway" {
#   source        = "./modules/cloud_nat"
#   project_id    = var.project_id
#   router_name   = var.ms_router_name
#   network       = module.vpc-module.ms_vpc_self_link
#   router_region = var.region
#   nat_name      = var.ms_nat_name
#   depends_on    = [module.enable-apis, module.vpc-module, module.assured-workload]
# }


module "container-registry" {
  source     = "./modules/container_registry"
  project_id = var.project_id
  location   = var.location
  depends_on = [module.enable-apis, module.assured-workload]
}

module "bigquery-module" {
  source                     = "./modules/bigquery"
  project_id                 = var.project_id
  cmek_project_id            = var.cmek_project_id
  bq_dataset_prefix          = var.bq_dataset_prefix
  dataset_name               = var.dataset_name
  description                = var.description
  delete_contents_on_destroy = var.delete_contents_on_destroy
  deletion_protection        = var.deletion_protection
  labels                     = var.labels
  tables                     = var.tables
  owner_email                = var.owner_email
  domain_name                = var.domain_name
  use_existing_keyring       = var.use_existing_keyring
  keyring_name               = var.keyring_name
  key_name                   = var.key_name
  location                   = var.region #var.location
  key_rotation_period        = var.key_rotation_period
  prevent_destroy            = var.prevent_destroy
  depends_on                 = [module.enable-apis, module.assured-workload]
}

module "bastion_host" {
  source               = "./modules/bastion_host"
  project_id           = var.project_id
  cmek_project_id      = var.cmek_project_id
  instance_prefix      = var.bastion_instance_prefix
  region               = var.region
  tags                 = var.bastion_tags
  disk_size_gb         = var.bastion_disk_size_gb
  machine_type         = var.bastion_machine_type
  num_instances        = var.bastion_num_instances
  instance_name        = var.bastion_instance_name
  source_image         = var.bastion_source_image
  source_image_project = var.bastion_source_image_project
  deletion_protection  = var.bastion_deletion_protection
  sa_prefix            = var.sa_prefix
  zone                 = var.bastion_zone
  network              = module.vpc-module.ms_vpc_self_link
  subnetwork           = module.vpc-module.ms_vpc_subnets[0]
  keyring_name         = var.bastion_keyring_name
  key_rotation_period  = var.key_rotation_period
  use_existing_keyring = var.bastion_use_existing_keyring
  depends_on           = [module.enable-apis, module.vpc-module, module.assured-workload]
  roles_list           = var.bastion_roles
}


module "gke-module" {
  source             = "./modules/gke"
  project_id         = var.project_id
  cmek_project_id    = var.cmek_project_id
  network_project_id = var.project_id
  network            = var.ms_vpc_name
  gke_settings = {
    gke1 = {
      name                      = var.gke_name
      subnetwork                = module.vpc-module.ms_vpc_subnets[0]
      ip_range_pods             = "${module.vpc-module.ms_vpc_subnets[0]}-pods"
      ip_range_services         = "${module.vpc-module.ms_vpc_subnets[0]}-services"
      master_ipv4_cidr_block    = var.master_internal_iprange
      enable_external_ip        = false
      default_max_pods_per_node = 100
      region                    = var.region
      node_locations            = var.node_zones
      node_pool_min_count       = 1
      node_pool_max_count       = 4
      machine_type              = "e2-standard-4"
      master_authorized_networks = [{
        cidr_block   = var.master_authorized_network_cidr
        display_name = "master-allowed-range1"
      }]
    }
  }
  compute_engine_service_account = var.compute_engine_service_account
  use_existing_keyring           = var.gke_use_existing_keyring
  keyring_name                   = var.gke_keyring_name
  region                         = var.region
  key_name                       = var.gke_key_name
  key_rotation_period            = var.key_rotation_period
  prevent_destroy                = var.prevent_destroy
  labels                         = var.labels
  depends_on                     = [module.enable-apis, module.vpc-module, module.assured-workload]
}

module "deep-learning-vm" {
  source                  = "./modules/compute_engine"
  project_id              = var.project_id
  cmek_project_id         = var.cmek_project_id
  compute_service_account = ""
  instance_prefix         = var.instance_prefix
  instance_name           = var.instance_name
  region                  = var.region
  zone                    = var.zone
  can_ip_forward          = var.can_ip_forward
  disk_size_gb            = var.disk_size_gb
  disk_type               = var.disk_type
  machine_type            = var.dl-machine_type
  roles_list              = var.roles_list
  tags                    = var.tags
  network                 = module.vpc-module.dl_vpc_name
  num_instances           = var.num_instances
  source_image            = var.source_image
  source_image_project    = var.source_image_project
  source_image_family     = var.source_image_family
  startup_script          = var.startup_script
  subnetwork              = module.vpc-module.dl_vpc_subnets[0]
  metadata                = var.metadata
  labels                  = var.dl-labels
  sa_prefix               = var.sa_prefix
  access_config           = var.access_config
  autoscaling_name        = var.autoscaling_name
  max_replicas            = var.max_replicas
  min_replicas            = var.min_replicas
  instance_group_name     = var.instance_group_name
  create_key              = var.create_key
  disk_encryption_key     = var.disk_encryption_key
  use_existing_keyring    = var.use_existing_keyring
  key_name                = var.dl-key_name
  keyring_name            = var.dl-keyring_name
  key_rotation_period     = var.key_rotation_period
  prevent_destroy         = var.prevent_destroy
  depends_on              = [module.enable-apis, module.vpc-module, module.assured-workload]
}

module "pubsub" {
  source               = "./modules/pubsub"
  project_id           = var.project_id
  cmek_project_id      = var.cmek_project_id
  location             = var.region
  topic_name           = var.topic_name
  create_topic         = true
  pull_subscriptions   = var.pull_subscriptions
  push_subscriptions   = var.push_subscriptions
  use_existing_keyring = var.pub_use_existing_keyring
  keyring_name         = var.pub_keyring_name
  topic_labels         = var.topic_labels
  subscription_labels  = var.subscription_labels
  depends_on           = [module.enable-apis, module.assured-workload]
}

module "logging-and-monitoring" {
  source           = "./modules/logging"
  project_id       = var.project_id
  log_sink_name    = var.log_sink_name
  sink_destination = "pubsub.googleapis.com/${module.pubsub.pubsub_id}"
  log_filters      = var.log_filters
  depends_on       = [module.enable-apis, module.assured-workload]
}

module "dns-module" {
  source      = "./modules/dns"
  project_id  = var.project_id
  name        = var.name
  dns_name    = var.dns_name
  labels      = var.dns_labels
  visibility  = var.visibility
  network_url = module.vpc-module.ms_vpc_self_link
  depends_on  = [module.enable-apis, module.assured-workload]
}

# Logging Data Pipeline

module "temp-bucket" {
  source               = "./modules/cloudstorage"
  project_id           = var.project_id
  cmek_project_id      = var.cmek_project_id
  names                = var.temp_bucket_name
  prefix               = var.temp_bucket_prefix
  bucket_location      = var.region #var.location
  storage_class        = var.storage_class
  versioning           = var.versioning
  lifecycle_rules      = var.lifecycle_rules
  use_existing_keyring = var.temp_bucket_use_existing_keyring
  keyring_name         = var.temp_keyring_name
  key_ring_location    = var.region #var.location
  key_rotation_period  = var.key_rotation_period
  labels               = var.labels
  gcs_admin_group_id   = ""
  gcs_write_group_id   = ""
  prevent_destroy      = var.prevent_destroy
  depends_on           = [module.enable-apis, module.assured-workload]
}


resource "google_storage_bucket_object" "pubsub_to_bq_job_udf" {
  name   = "udf/pubsub-bq/transform.js"
  source = var.local_location_of_udf_pubsub_to_bq
  bucket = module.temp-bucket.name
}


module "bigquery-module-pipeline" {
  source                     = "./modules/bigquery"
  depends_on                 = [module.enable-apis, module.assured-workload]
  project_id                 = var.project_id
  cmek_project_id            = var.cmek_project_id
  bq_dataset_prefix          = var.bq_dataset_prefix
  dataset_name               = var.bq_dataset_name
  description                = var.bq_description
  delete_contents_on_destroy = var.bq_delete_contents_on_destroy
  deletion_protection        = var.bq_deletion_protection
  labels                     = var.bq_labels
  tables = [
    {
      table_id = var.pubsub_to_bq_table_id
      schema   = file(var.pubsub_to_bq_table_schema_file_path)
      #schema     = null
      clustering = []
      time_partitioning = {
        type                     = var.table_partition_type
        require_partition_filter = false
        field                    = null,
        expiration_ms            = null,
      },
      range_partitioning = null
      expiration_time    = null
      labels             = var.bq_labels
    }
  ]
  owner_email          = var.bq_owner_group_email
  domain_name          = var.domain_name
  enable_cmek          = var.enable_cmek
  use_existing_keyring = var.bigquery_use_existing_keyring
  keyring_name         = var.bq_pipeline_keyring_name
  key_name             = var.bigquery_key_name
  location             = var.location
  key_rotation_period  = var.key_rotation_period
  prevent_destroy      = var.prevent_destroy
}

module "dataflow-serviceaccount" {
  source                     = "./modules/service_account"
  project_id                 = var.project_id
  account_id                 = var.dataflow_service_account_id
  display_name               = var.dataflow_service_account_display_name
  description                = "GKE Model hosting service account"
  create_sa_key              = false
  service_account_roles_list = var.dataflow_service_account_roles_list
  depends_on                 = [module.enable-apis, module.assured-workload]
}

module "dataflow_access" {
  source                          = "./modules/dataflow_iam"
  project_id                      = var.project_id
  dataflow_temporary_gcs_bucket   = module.temp-bucket.name
  give_access_to_bigquery         = true
  give_access_to_storage          = true
  give_access_to_pubsub           = true
  dataset_id                      = module.bigquery-module-pipeline.dataset_id
  bucket_name                     = module.temp-bucket.name
  subscription_name               = module.pubsub.subscription_path[0]
  dataflow_worker_service_account = module.dataflow-serviceaccount.email
  depends_on                      = [module.enable-apis, module.assured-workload]
}

module "dataflow-pubsub-to-bq" {
  source                        = "./modules/dataflow"
  project_id                    = var.project_id
  cmek_project_id               = var.cmek_project_id
  dataflow_job_name             = var.pubsub_to_bq_dataflow_job_name
  dataflow_template_gcs_path    = var.pubsub_to_bq_dataflow_template_gcs_path
  dataflow_temporary_gcs_bucket = module.temp-bucket.url
  enable_streamin_engine        = var.enable_streamin_engine
  parameters = {
    inputSubscription                   = module.pubsub.subscription_path[0]
    outputTableSpec                     = "${var.project_id}:${module.bigquery-module-pipeline.dataset_id}.${var.pubsub_to_bq_table_id}"
    javascriptTextTransformGcsPath      = "${module.temp-bucket.url}/udf/pubsub-bq/transform.js"
    javascriptTextTransformFunctionName = var.pubsub_to_bq_udf_funtion_name
  }
  dataflow_max_workers  = var.dataflow_max_workers
  dataflow_network      = var.dataflow_network_name
  dataflow_subnetwork   = "regions/${var.region}/subnetworks/${var.pubsub-to-bq-subnet_name}"
  location              = var.region
  use_existing_keyring  = var.dataflow_use_existing_keyring
  key_name              = var.pubsub_to_bq_dataflow_key_name
  keyring_name          = var.df_keyring_name
  key_rotation_period   = var.key_rotation_period
  service_account_email = module.dataflow-serviceaccount.email
  depends_on            = [module.enable-apis, module.assured-workload]
}
