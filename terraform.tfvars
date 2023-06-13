billing_account                 = "billingAccounts/011A35-FD2527-D53035"                 # Billing associated with the GCP account
compliance_regime               = "FEDRAMP_HIGH"                                         # Compliance regime for assured workloads
assured_workload_name           = "aswl23-fldr-fedramph"                                 # Assured Workload Folder Name to be created
project_number                  = "304179763222"                                         # Assured workload project number
project_id                      = "assured-fedramp"                                      # Assured Workload Project Id
cmek_project_id                 = "aswl23-fedramp-cmek-proj"                             # CMEK project ID to be created
location                        = "us"                                                   # Assured Worload location
organization_id                 = "468180499708"                                         # GCP account org id
next_rotation_time              = "9999-10-02T15:01:23Z"                                 # The time at which the Key Management Service will automatically create a new version of the crypto key and mark it as the primary
rotation_period                 = "10368000s"                                            # will be advanced by this period when the Key Management Service automatically rotates a key
assured_workloads_labels        = { "name" = "fedramphigh" }                             # Assured workload labels
parent_resource                 = null                                                   # If null this varaible takes the organization as parent for Assured workload Folder
ms_vpc_name                     = "ml-model-vpc"                                         # VPC for runnning  ml model 
dl_vpc_name                     = "dl-vpc"                                               # vpc for deep leaning vms
secondary_pods_subnet_range     = "10.3.0.0/16"                                          # secondary pod ranges for ml model vpc
secondary_services_subnet_range = "10.4.0.0/20"                                          # secondary service ranges for ml model vpc
dataset_name                    = "ml_fedramp_features"                                  # Bigquery dataset name 
owner_email                     = "dataadmins@assuredworkloadsfortesting.com"            # Group Email Id for BigQuery access (Data Admin group email id)
domain_name                     = "assuredworkloadsfortesting.com"                       # domain name - BigQuery
bq_dataset_prefix               = "fh"                                                   # prefix for bigquery dataset
description                     = "FedRAMP authorized zone model dataset"                # description for bigquery dataset
delete_contents_on_destroy      = true                                                   # delete all the tables in the dataset when destroying the resource
deletion_protection             = false                                                  # Whether or not to allow Terraform to destroy the instance
create_key                      = true                                                   #  KMS Variables
use_existing_keyring            = false                                                  # Use existing keyring for bigquery
keyring_name                    = "kring01-009"                                          #Bigquery key ring
key_name                        = "fedramp-high-ml-dset-key"                             # Name of the key
key_rotation_period             = "7776000s"                                             # key rotaion perion
prevent_destroy                 = true                                                   # prevent destroy on key deletion
gke_name                        = "gke-hosting-cluster"                                  # Name of GKE cluster
master_internal_iprange         = "10.5.0.0/28"                                          # The IP range in CIDR notation to use for the hosted master network
master_authorized_network_cidr  = "10.0.0.0/16"                                          # Authorized network ip to access cluster
compute_engine_service_account  = ""                                                     # creates new service account if empty
gke_use_existing_keyring        = false                                                  # use existing keyring
gke_keyring_name                = "kring01-00110"                                        # key ring name for GKE
gke_key_name                    = "gke-etcd-encrypt2-key"                                # key name for GKE
region                          = "us-central1"                                          # region to deploy the regional resources
node_zones                      = "us-central1-a,us-central1-b,us-central1-c"            # node locations
instance_prefix                 = "instance-template-"                                   # instance template prefix
instance_name                   = "deep-learning-vm"                                     # Name of the deep learning vm
can_ip_forward                  = false                                                  # deny forwarding ip if set to false
disk_size_gb                    = "100"                                                  # size of disk - deep learning vm
disk_type                       = "pd-standard"                                          # disk type - deep learning vm
dl-machine_type                 = "n1-standard-1"                                        # machine type - deep learning vm
tags                            = []                                                     # instance tags
num_instances                   = "1"                                                    # numer of instances
source_image                    = "tf2-latest-cpu-v20211202-ubuntu-2004"                 # Source image - deep learning vm
source_image_project            = "deeplearning-platform-release"                        # source project - deep learning vm
source_image_family             = "tf2-latest-cpu-ubuntu-2004"                           # source image family - deep learning vm
sa_prefix                       = "fr"                                                   # service account prefix
zone                            = "us-central1-a"                                        # zone - deep learning vm
autoscaling_name                = "deeplearningscale-sample"                             # auto scaling name
max_replicas                    = "3"                                                    # max replicas
min_replicas                    = "0"                                                    # min replicas
instance_group_name             = "dl-instance-group-sample"                             # instance group name - deep learning vm
dl-key_name                     = "dl-key3"                                              # key name - deep learning vm
dl-keyring_name                 = "kring1-0015"                                          # key ring name - deep learning vm
name                            = "dns-private-zone-fedramp"                             # DNS private zone name
dns_name                        = "example.com."                                         # DNS name
visibility                      = "private"                                              # privte DNS zone if value is "private"
super_admin_group_email         = "superadmins@assuredworkloadsfortesting.com"           # These are IAM groups that we have created - Super admin  group email id
admin_group_email               = "admins@assuredworkloadsfortesting.com"                # These are IAM groups that we have created - Admin admin group email id
modeladmin_group_email          = "modeladmins@assuredworkloadsfortesting.com"           # These are IAM groups that we have created - Model Admin group email id
dataadmin_group_email           = "dataadmins@assuredworkloadsfortesting.com"            # These are IAM groups that we have created - Data Admin group email id
networksecadmin_group_email     = "networksecurityadmins@assuredworkloadsfortesting.com" # These are IAM groups that we have created - Network and Security admin email id
log_sink_name                   = "logsinkfedramp"                                       # Log sink name
topic_name                      = "logging-topic1"                                       # pubsub topic name
pull_subscriptions = [
  {
    name = "pull-test"
    additional_settings = {
      enable_message_ordering = true
    }
  }
] #  Pub/Sub Subscription name

# Logging pipeline variables

dataflow_network_name    = "fedramp-dataflow-network"             # Dataflow vpc network name
pubsub-to-bq-subnet_name = "fedramp-pubsub-to-bq-dataflow-subnet" # Dataflow subnet name
pubsub-to-bq-subnet_ip   = "10.1.0.0/16"                          # Subnet ip 
firewall_rules           = []                                     # Firewall rules 

dataflow_service_account_id           = "dataflow-worker-sa" # Service account name
dataflow_service_account_display_name = "dataflow-worker-sa" # Service account display name
dataflow_service_account_roles_list   = ["roles/owner"]      # Service account access role

pubsub_to_bq_dataflow_job_name          = "pubsub-to-bq-streaming-job"                                     # Dataflow job name
pubsub_to_bq_dataflow_template_gcs_path = "gs://dataflow-templates/latest/PubSub_Subscription_to_BigQuery" # Template gcs path
pubsub_to_bq_udf_funtion_name           = "transform"                                                      # UDF function name
pub_use_existing_keyring                = false                                                            # use existing key ring
pub_keyring_name                        = "kring01-011"                                                    # key ring name
pubsub_to_bq_dataflow_key_name          = "pubsub-to-bq-job-key"                                           # key name
local_location_of_udf_pubsub_to_bq      = "/home/mmasooduddin/FH_Drive/dataflow-udf/transform.js"          # location path of UDF function
dataflow_max_workers                    = 2                                                                # max dataflow workers
storage_class                           = "REGIONAL"                                                       # Storage class for GCS bucket
versioning                              = false                                                            # Wheteher versioning shpuld be enabled
lifecycle_rules                         = []                                                               # life cycle rules for bucket format - [({ condition = { age = 365 }, action = { type = "SetStorageClass", storage_class = "COLDLINE" } })]
gcs_admin_group_id                      = "admins@assuredworkloadsfortesting.com"                          # The gcs admin group id that will be connected to the buckets
gcs_write_group_id                      = "admins@assuredworkloadsfortesting.com"                          # The gcs write group id that will be connected to the buckets

temp_bucket_name                    = ["temp-storage-bucket-dataflow"]                      # bucket name
temp_bucket_prefix                  = "fedramp"                                             # bucket prefix name
temp_bucket_use_existing_keyring    = false                                                 # use existing key ring
temp_keyring_name                   = "kring-0018"                                          # key ring name
dataflow_use_existing_keyring       = false                                                 # use existing key ring
df_keyring_name                     = "kring01-0022"                                        # key ring name for data flow
bq_dataset_name                     = "mlreadydataset"                                      # bigquery dataset name
bq_owner_group_email                = "dataadmins@assuredworkloadsfortesting.com"           # Group Email Id for BigQuery access (Data Admin group email id)
bq_domain_name                      = "assuredworkloadsfortesting.com"                      # Domain name for biqquery access
pubsub_to_bq_table_id               = "pubsub-to-bq-transform-table1"                       # table name
pubsub_to_bq_table_schema_file_path = "/home/mmasooduddin/FH_Drive/schema/tableschema.json" # path to schema
bq_pipeline_keyring_name            = "kring1-0020"                                         # Keyring name for bigquery
bigquery_key_name                   = "fedramp-ml-dataset-key"                              # Bigquery key name
bastion_instance_prefix             = "fedramp-bastion"                                     # instance template prefix for bastion host
bastion_instance_name               = "bastion-vm-gke"                                      # instance name of bastion host
bastion_disk_size_gb                = "50"                                                  # disk size of bastion host vm
bastion_tags                        = ["bastion"]                                           # tags for bastion instance
bastion_machine_type                = "n2d-standard-4"                                      # machine type - bastion
bastion_num_instances               = "1"                                                   # No. of instances - bastion
bastion_source_image                = "ubuntu-2004-lts"                                     # Source image - bastion
bastion_source_image_project        = "ubuntu-os-cloud"                                     # Source image project - bastion
bastion_zone                        = "us-central1-b"                                       # Zone - bastion
bastion_deletion_protection         = false                                                 # deletion protection for bastion instance
bastion_roles                       = ["roles/compute.admin"]                               # role for bastion host service account
bastion_use_existing_keyring        = false                                                 # use existing keyring
bastion_keyring_name                = "kring1-8016"                                         # keyring name for bastion
