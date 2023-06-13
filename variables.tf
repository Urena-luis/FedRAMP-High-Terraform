variable "billing_account" {
  description = "Billing accoint id in format billingAccounts/<id>"
  type        = string
}

variable "compliance_regime" {
  description = ""
  type        = string
  default     = "FEDRAMP_HIGH"
}

variable "assured_workload_name" {
  description = "Assure workload name. It will the assured workload folder with the same name"
  type        = string
}

variable "organization_id" {
  description = "Organization id"
  type        = string
}

variable "next_rotation_time" {
  description = "rotaion time"
  type        = string
}

variable "rotation_period" {
  description = "Rotation period in seconds to be used for KMS Key"
  type        = string
}

variable "assured_workloads_labels" {
  description = "Assured workload labels"
  type        = map(string)
  default = {
    name = "fedramp-high"
  }
}

variable "parent_resource" {
  description = "Set this value to null to create the GCP folder under the org"
  type        = string
  default     = null
  #default = "folders/<FOLDER_ID>"
}

variable "project_number" {
  description = "project number to pass at the resource id"
  type        = string
}

variable "project_id" {
  description = "Project id"
  type        = string
}

variable "cmek_project_id" {
  description = "cmek Project id"
  type        = string
}

#Variable to move project to assured workloads folder

# variable "aw_parent_id" {
#   description = "Assured workloads folder id - folder id/org id."
#   type        = string
#   #default      = "777227722859"
# }


# VPC Varaibles

variable "ms_vpc_name" {
  description = "The name of the Model serving cluster VPC network being created"
  type        = string
  default     = "ml-model-vpc"
}

variable "ms-subnets" {
  type        = list(map(string))
  description = "The list of subnets being created"
  default = [{
    subnet_name           = "ms-subnet-name"
    subnet_ip             = "10.0.0.0/16"
    subnet_region         = "us-central1"
    subnet_private_access = "true"
    subnet_flow_logs      = "true"
  }]
}

variable "dl_vpc_name" {
  description = "The name of the dl VPC network being created"
  type        = string
  default     = "dl-vpc"
}

variable "dl-subnets" {
  type        = list(map(string))
  description = "The list of subnets being created"
  default = [{
    subnet_name           = "dl-subnet-name"
    subnet_ip             = "10.1.0.0/16"
    subnet_region         = "us-central1"
    subnet_private_access = "true"
    subnet_flow_logs      = "true"
  }]
}

variable "secondary_pods_subnet_range" {
  description = "Secondary IP ranges for GKE Pods"
  type        = string
  default     = "10.3.0.0/16"
}

variable "secondary_services_subnet_range" {
  description = "Secondary IP ranges for GKE Services"
  type        = string
  default     = "10.4.0.0/20"
}

variable "ms-firewall-rules" {
  type        = any
  description = "Firewall rules to configure for ms cluster vpc network"
  default = [
    {
      name        = "ms-firewall"
      description = "ms firewall rules"
      direction   = "INGRESS"
      source_tags = ["ms"]
      allow = [{
        protocol = "tcp"
        ports    = ["1433"]
      }]
      log_config = {
        metadata = "INCLUDE_ALL_METADATA"
      }
    },
    {
      name                    = "health-check"
      description             = "ms firewall rules - hc"
      direction               = "INGRESS"
      ranges                  = ["35.191.0.0/16", "130.211.0.0/22"]
      destination_ranges      = null
      source_tags             = null
      target_tags             = null
      source_service_accounts = null
      target_service_accounts = null
      priority                = null
      allow = [{
        protocol = "tcp"
        ports    = null
      }]
      deny       = []
      log_config = null
    },
    {
      name                    = "iap"
      description             = "ms firewall rules - iap"
      direction               = "INGRESS"
      ranges                  = ["35.235.240.0/20"]
      destination_ranges      = null
      source_tags             = null
      target_tags             = null
      source_service_accounts = null
      target_service_accounts = null
      priority                = null
      allow = [{
        protocol = "tcp"
        ports    = ["22"]
      }]
      deny       = []
      log_config = null
  }]
}

variable "dl-firewall-rules" {
  type        = any
  description = "Firewall rules to configure for dl vpc network"
  default = [
    #     {
    #       name        = "dl-firewall"
    #       description = "dl vpc firewall rules"
    #       direction   = "INGRESS"
    #       source_tags = ["dl"]
    #       allow = [{
    #         protocol = "tcp"
    #         ports    = ["22"]
    #       }]
    #       log_config = {
    #         metadata = "INCLUDE_ALL_METADATA"
    #       }
    #   },
    {
      name                    = "iap-dl"
      description             = "dl firewall rules - iap"
      direction               = "INGRESS"
      ranges                  = ["35.235.240.0/20"]
      destination_ranges      = null
      source_tags             = null
      target_tags             = null
      source_service_accounts = null
      target_service_accounts = null
      priority                = null
      allow = [{
        protocol = "tcp"
        ports    = ["22"]
      }]
      deny       = []
      log_config = null
  }]
}

# # NAT Variables

# variable "ms_router_name" {
#   description = "Name of the router"
#   type        = string
#   default     = "ml-router"
# }

# variable "ms_nat_name" {
#   description = "Name of the NAT"
#   type        = string
#   default     = "ml-nat"
# }

# Container Registry Varaibles

variable "cr-location" {
  description = "Container registry location"
  type        = string
  default     = "us"
}

# BigQuery Variables

variable "dataset_name" {
  description = "The dataset name."
  type        = string
  default     = "ml_fedramp_features"
}

variable "owner_email" {
  description = "Big query owner email"
  type        = string
  default     = "admin@assuredworkloadsfortesting.com"
}

variable "domain_name" {
  description = "Domain to give read access to."
  type        = string
}

variable "bq_dataset_prefix" {
  description = "Prefix for dataset id."
  type        = string
  default     = "bq"
}

variable "location" {
  description = "Case-Sensitive Location for Big Query dataset (Should be same region as the KMS Keyring)"
  type        = string
  default     = "us-central1"
}

variable "description" {
  description = "Description about the dataset"
  type        = string
  default     = "FedRAMP authorized zone model dataset"
}

variable "labels" {
  description = "Labels provided as a map"
  type        = map(string)
  default = {
    key1 = "value1"
  }
}

variable "delete_contents_on_destroy" {
  description = "If set to true, delete all the tables in the dataset when destroying the resource; otherwise, destroying the resource will fail if tables are present."
  type        = bool
  default     = true
}

variable "deletion_protection" {
  description = "Whether or not to allow Terraform to destroy the instance. Unless this field is set to false in Terraform state, a terraform destroy or terraform apply that would delete the instance will fail"
  type        = bool
  default     = false
}

variable "tables" {
  description = "A list of objects which include table_id, schema, clustering, time_partitioning, range_partitioning, expiration_time and labels."
  default     = []
  type = list(object({
    table_id   = string,
    schema     = string,
    clustering = list(string),
    time_partitioning = object({
      expiration_ms            = string,
      field                    = string,
      type                     = string,
      require_partition_filter = bool,
    }),
    range_partitioning = object({
      field = string,
      range = object({
        start    = string,
        end      = string,
        interval = string,
      }),
    }),
    expiration_time = string,
    labels          = map(string),
  }))
}

#################################
# BigQuery KMS Variables
################################

variable "create_key" {
  description = "If you want to use a KMS key then select this"
  type        = bool
  default     = true
}

variable "enable_cmek" {
  description = "Enable Customer Managed Encryption Key"
  type        = bool
  default     = true
}

variable "use_existing_keyring" {
  description = "If you want to use an existing keyring and don't create a new one -> true"
  type        = bool
  default     = false
}

variable "keyring_name" {
  description = "Name to be used for KMS Keyring"
  type        = string
  default     = "fedramp-high-zone-keyring1"
}

variable "pub_use_existing_keyring" {
  description = "If you want to use an existing keyring and don't create a new one -> true"
  type        = bool
  default     = false
}

variable "pub_keyring_name" {
  description = "Name to be used for KMS Keyring"
  type        = string
  default     = "fedramp-high-zone-keyring1"
}

variable "key_name" {
  description = "Name to be used for key"
  type        = string
  default     = "fedramp-high-ml-dataset-key"
}

variable "key_rotation_period" {
  description = "Rotation period in seconds to be used for KMS Key"
  type        = string
  default     = "7776000s"
}

variable "prevent_destroy" {
  description = "Prevent bucket key destroy on KMS"
  type        = bool
  default     = true
}
#******************************
# GKE Variables  
#*****************************

variable "gke_name" {
  description = "Name of the GKE cluster"
  type        = string
  default     = "model-hosting-cluster"
}

variable "master_internal_iprange" {
  description = "Internal IP range of master"
  type        = string
  default     = "10.5.0.0/28"
}

variable "master_authorized_network_cidr" {
  description = "Master authorized IPs CIDR ranges 1"
  type        = string
  default     = "10.6.0.0/16"
}

variable "compute_engine_service_account" {
  type        = string
  description = "The service account email"
  default     = ""
}

variable "gke_use_existing_keyring" {
  description = "If you want to use an existing keyring and don't create a new one -> true"
  type        = bool
  default     = false
}

variable "gke_keyring_name" {
  type        = string
  description = "Key ring for GKE Database encryption"
  default     = "gke-key-ring"
}

variable "gke_key_name" {
  type        = string
  description = "The service account email"
  default     = "gke-etcd-encryption-key"
}

variable "node_zones" {
  type        = string
  description = "define node zones"
}

# variable "enforce_bin_auth_policy" {
#   type        = bool
#   description = "Enable or Disable creation of binary authorization policy."
#   default     = false
# }

# variable "bin_auth_attestor_names" {
#   type        = list(string)
#   description = "Binary Authorization Attestor Names set up in shared app_cicd project."
#   default = ["bin-attestor-names1"]
# }

# variable "attestors_keyring_id" {
#   type        = string
#   description = "The attestors keyring id"

# }

# variable "allowlist_patterns" {
#   type        = list(string)
#   description = "The google binary authorization policy allowlist patterns"
#   default     = ["gcr.io/config-management-release/*"]
# }




#******************************************
#  Deep Learning VM module
#*******************************************

variable "instance_prefix" {
  description = "Name prefix for the instance template"
  type        = string
  default     = "instance-template-"
}

variable "instance_name" {
  description = "Name for the instance template"
  type        = string
  default     = "deep-learning-vm"
}


variable "can_ip_forward" {
  description = "Enable IP forwarding, for NAT instances for example"
  type        = string
  default     = "false"
}

variable "disk_size_gb" {
  description = "Boot disk size in GB"
  type        = string
  default     = "100"
}

variable "disk_type" {
  description = "Boot disk type, can be either pd-ssd, local-ssd, or pd-standard"
  type        = string
  default     = "pd-standard"
}

variable "dl-machine_type" {
  description = "Machine type to create, e.g. n1-standard-1"
  type        = string
  default     = "n1-standard-1"
}

variable "roles_list" {
  description = "roles list for the service account"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Network tags, provided as a list"
  type        = list(string)
  default     = ["dl-vpc"]
}

variable "num_instances" {
  description = "Number of instances to create."
  type        = string
  default     = "1"
}

variable "source_image" {
  description = "Source disk image. If neither source_image nor source_image_family is specified, defaults to the latest public CentOS image."
  type        = string
  default     = "tf2-latest-cpu-v20211202-ubuntu-2004"
}

variable "source_image_project" {
  description = "Source Image Project"
  type        = string
  default     = "deeplearning-platform-release"
}
variable "source_image_family" {
  description = "Source image family"
  type        = string
  default     = "tf2-latest-cpu-ubuntu-2004"
}

variable "startup_script" {
  description = "User startup script to run when instances spin up"
  type        = string
  default     = ""
}

variable "metadata" {
  description = "Metadata provided as a map"
  type        = map(string)
  default = {
    serial-port-enable = false,
    enable-oslogin     = true
  }
}

variable "dl-labels" {
  description = "Labels provided as a map"
  type        = map(string)
  default     = {}
}

variable "sa_prefix" {
  description = "Name prefix for the service account"
  type        = string
  default     = "default"
}

variable "access_config" {
  description = "Access configurations, i.e. IPs via which the VM instance can be accessed via the Internet. The networking tier used for configuring this instance. This field can take the following values: PREMIUM or STANDARD."
  type = list(object({
    nat_ip       = string
    network_tier = string
  }))
  default = []
}

variable "region" {
  type        = string
  description = "Name of the region"
}

variable "zone" {
  type        = string
  description = "Zone where the instances should be created. If not specified, instances will be spread across available zones in the region."
  default     = "us-central1-a"
}


/******************************************
  Autoscaling
*****************************************/

variable "autoscaling_name" {
  description = "Name of autoscaling policy"
  type        = string
  default     = "deeplearningscale-sample"
}

variable "max_replicas" {
  description = "The minimum number of replicas that the autoscaler can scale down to. This cannot be less than 0. If not provided, autoscaler will choose a default value depending on maximum number of instances allowed."
  type        = string
  default     = "3"
}

variable "min_replicas" {
  description = "The maximum number of instances that the autoscaler can scale up to. This is required when creating or updating an autoscaler. The maximum number of replicas should not be lower than minimal number of replicas."
  type        = string
  default     = "0"
}


/******************************************
  Instance Group
*****************************************/
variable "instance_group_name" {
  description = "Name of instance group"
  type        = string
  default     = "dl-instance-group-sample"
}



/******************************************
  Deep Learning VM KMS
*****************************************/

variable "disk_encryption_key" {
  description = "The self link of the encryption key that is stored in Google Cloud KMS to use to encrypt all the disks on this instance"
  type        = string
  default     = ""
}


variable "dl-key_name" {
  description = "Name to be used for KMS Key for CMEK"
  type        = string
  default     = "dl-key-sample"
}

variable "dl-keyring_name" {
  description = "Name to be used for KMS Keyring for CMEK"
  type        = string
  default     = "fedrampkey-ijzcl"
}


#**********************************
#   Logging Variables
#**********************************

variable "log_sink_name" {
  description = "Name of the log sink"
  type        = string
  default     = "logsinkfedramp"
}


variable "log_filters" {
  description = "Name of the log sink"
  type        = string
  default     = ""
}


# variable "monitoring_alerts" {
#   type = map(object({
#     display_name           = string
#     combiner               = string
#     display_name_condition = string
#     filter                 = string
#     duration               = string
#     comparison             = string
#     alignment_period       = string
#     per_series_aligner     = string
#   }))
#   default = {}
# }



#*************************************
#  DNS Variables
#*************************************

variable "name" {
  type        = string
  description = "Display name of DNS Zone"
  default     = "dns-private-zone-fedramp"
}

// You need to add a period at the end of the domain name 
variable "dns_name" {
  type        = string
  description = "Domain name you own. ex: abc.com."
  default     = "example.com."
}

variable "dns_labels" {
  type        = any
  description = "labels"
  default     = {}
}

variable "visibility" {
  type        = string
  description = "Setting for public or private dns zone"
  default     = "private"
}

# IAM Group emails

variable "super_admin_group_email" {
  type        = string
  description = "Email of the metioned vaiable group"
}

variable "admin_group_email" {
  type        = string
  description = "Email of the metioned vaiable group"
}

variable "modeladmin_group_email" {
  type        = string
  description = "Email of the metioned vaiable group"
}

variable "dataadmin_group_email" {
  type        = string
  description = "Email of the metioned vaiable group"
}

variable "networksecadmin_group_email" {
  type        = string
  description = "Email of the metioned vaiable group"
}

#PubSub variables

variable "topic_name" {
  type        = string
  description = "The name for the Pub/Sub topic"
}

variable "create_topic" {
  type        = bool
  description = "Specify true if you want to create a topic"
  default     = true
}

variable "topic_labels" {
  type        = map(string)
  description = "A map of labels to assign to the Pub/Sub topic"
  default = {
    compliance = "fedramp-high"
  }
}

variable "subscription_labels" {
  type        = map(string)
  description = "A map of labels to assign to every Pub/Sub subscription"
  default = {
    compliance = "fedramp-high"
  }
}

variable "push_subscriptions" {
  type = list(object({
    name                = string
    push_endpoint       = string
    additional_settings = map(string)
  }))
  description = "The list of the push subscriptions"
  default     = []
}

variable "pull_subscriptions" {
  type = list(object({
    name                = string
    additional_settings = map(string)
  }))
  description = "The list of the pull subscriptions"
  default     = []
}

# Pipeline Variables

/******  DATAFLOW VPC Network variables ********/

variable "dataflow_network_name" {
  description = "Network where dataflow workers are hosted"
  type        = string
}

variable "pubsub-to-bq-subnet_name" {
  type        = string
  description = "dataflow subnet name"
}

variable "pubsub-to-bq-subnet_ip" {
  type        = string
  description = "dataflow subnet name"
}

variable "firewall_rules" {
  type        = any
  description = "Firewall rules to configure for dataflowvpc network"
  default     = []
}
/******  DATAFLOW Service Account Variables ***********/

variable "dataflow_service_account_id" {
  description = "Dataflow service account ID"
  type        = string
}

variable "dataflow_service_account_display_name" {
  description = "Dataflow service account display name"
  type        = string
}

variable "dataflow_service_account_roles_list" {
  description = "List of apis necessary for the project"
  type        = list(string)
}
/******  DATAFLOW variables ********/

variable "pubsub_to_bq_dataflow_job_name" {
  description = "Dataflow job name"
  type        = string
}


variable "pubsub_to_bq_dataflow_template_gcs_path" {
  description = "GCS bucket where Dataflow pipeline template is stored"
  type        = string
}

variable "enable_streamin_engine" {
  description = "Enable/disable the use of Streaming Engine for the job"
  type        = bool
  default     = true
}


variable "dataflow_max_workers" {
  description = "Number of dataflow workers should run parallelly"
  type        = number
}

variable "dataflow_use_existing_keyring" {
  description = "If you want to use an existing keyring and don't create a new one -> true"
  type        = bool
  default     = true
}

variable "df_keyring_name" {
  description = "Name to be used for KMS Keyring"
  type        = string
}

variable "pubsub_to_bq_dataflow_key_name" {
  description = "Name to be used for KMS Key for CMEK"
  type        = string
}

variable "local_location_of_udf_pubsub_to_bq" {
  description = "Location of UDF"
  type        = string
}

variable "pubsub_to_bq_udf_funtion_name" {
  description = "UDF function name"
  type        = string
}


/********* Temp Bucket Variables ************/

variable "temp_bucket_name" {
  type        = list(string)
  description = "Bucket name suffixes."
  default     = ["temp-storage-bucket-dataflow"]
}

variable "temp_bucket_prefix" {
  type        = string
  description = "Prefix used to generate the bucket name"
  default     = "fedramp"
}

variable "temp_bucket_use_existing_keyring" {
  description = "If you want to use an existing keyring and don't create a new one -> true"
  type        = bool
  default     = true
}

variable "storage_class" {
  type        = string
  description = "Storage class"
  default     = "REGIONAL"
}

variable "gcs_admin_group_id" {
  description = "The gcs admin group id that will be connected to the buckets"
  type        = string
}

variable "gcs_write_group_id" {
  description = "The gcs write group id that will be connected to the buckets"
  type        = string
}

variable "versioning" {
  type        = bool
  description = "Versioning of the buckets"
}

variable "lifecycle_rules" {
  type = set(object({
    action    = map(string)
    condition = map(string)
  }))
  description = "List of lifecycle rules to configure. Format is the same as described in provider documentation https://www.terraform.io/docs/providers/google/r/storage_bucket.html#lifecycle_rule except condition.matches_storage_class should be a comma delimited string."
}

variable "temp_keyring_name" {
  description = "If you want to use an existing keyring and don't create a new one -> true"
  type        = string
}



/********* BigQuery Variables ************/


variable "bq_dataset_name" {
  description = "The dataset name."
  type        = string
}

variable "bq_owner_group_email" {
  description = "Big query owner email"
  type        = string
  default     = "user:mmasooduddin@assuredworkloadsfortesting.com"
}

variable "bq_domain_name" {
  description = "Domain to give read access to."
  type        = string
  default     = ""
}

variable "bq_description" {
  description = "Description about the dataset"
  type        = string
  default     = "fedramp complianct dataset"
}

variable "bq_labels" {
  description = "Labels provided as a map"
  type        = map(string)
  default = {
    compliance = "fedramp"
  }
}

variable "bq_delete_contents_on_destroy" {
  description = "If set to true, delete all the tables in the dataset when destroying the resource; otherwise, destroying the resource will fail if tables are present."
  type        = bool
  default     = true
}

variable "bq_deletion_protection" {
  description = "Whether or not to allow Terraform to destroy the instance. Unless this field is set to false in Terraform state, a terraform destroy or terraform apply that would delete the instance will fail"
  type        = bool
  default     = false
}

variable "bq_pipeline_keyring_name" {
  description = "If you want to use an existing keyring and don't create a new one -> true"
  type        = string
}

variable "pubsub_to_bq_table_id" {
  description = "pubsub to bigquery data transform storage table id."
  type        = string
}

variable "pubsub_to_bq_table_schema_file_path" {
  description = "local Schema file path for pubsub to bigquery data transform storage table id"
  type        = string
}

variable "table_partition_type" {
  description = "BQ table partition type."
  type        = string
  default     = "DAY"
}

# variable "tables" {
#   description = "A list of objects which include table_id, schema, clustering, time_partitioning, range_partitioning, expiration_time and labels."
#   default = []
#   type = list(object({
#     table_id   = string,
#     schema     = string,
#     clustering = list(string),
#     time_partitioning = object({
#       expiration_ms            = string,
#       field                    = string,
#       type                     = string,
#       require_partition_filter = bool,
#     }),
#     range_partitioning = object({
#       field = string,
#       range = object({
#         start    = string,
#         end      = string,
#         interval = string,
#       }),
#     }),
#     expiration_time = string,
#     labels          = map(string),
#   }))
#}

/********* BigQuery's KMS Variables ************/

variable "bigquery_use_existing_keyring" {
  description = "If you want to use an existing keyring and don't create a new one -> true"
  type        = bool
  default     = true
}


variable "bigquery_key_name" {
  description = "Name to be used for key"
  type        = string
  default     = ""
}

/*************** Bastion Host Module *********/


variable "bastion_instance_prefix" {
  description = "value"
  type        = string
  default     = "itar"
}

variable "bastion_instance_name" {
  description = "bastion instance name to connect to GKE"
  type        = string
}


variable "bastion_tags" {
  description = "Tags for db instance"
  type        = list(string)
}

variable "bastion_disk_size_gb" {
  description = "Boot disk size in GB"
  type        = string
  default     = "50"
}

variable "bastion_disk_type" {
  description = "Boot disk type, can be either pd-ssd or pd-standard"
  type        = string
  default     = "pd-standard"
}

variable "bastion_machine_type" {
  description = "Machine type to create. Note that the instance image must support Confidential VMs"
  type        = string
}

variable "bastion_zone" {
  description = "Zone of db instnace"
  type        = string
  default     = null
}

variable "bastion_num_instances" {
  description = "Number of instances to create."
  type        = string
  default     = "1"
}

variable "bastion_source_image" {
  description = "Source disk image. Note that the instance image must support Confidential VMs."
  type        = string
}

variable "bastion_source_image_project" {
  description = "Source disk image project. Note that the instance image must support Confidential VMs."
  type        = string
}

variable "bastion_deletion_protection" {
  description = "Enable deletion protection on this instance. Note: you must disable deletion protection before removing the resource, or the instance cannot be deleted and the Terraform run will not complete successfully."
  type        = bool
}

variable "bastion_roles" {
  description = "roles required for the bastion host service account"
  type        = list(string)

}

variable "bastion_use_existing_keyring" {
  description = "If you want to use an existing keyring and don't create a new one -> true"
  type        = bool
  default     = true
}

variable "bastion_keyring_name" {
  description = "If you want to use an existing keyring and don't create a new one -> true"
  type        = string
}
