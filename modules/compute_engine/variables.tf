variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "cmek_project_id" {
  description = "The cmek project ID"
  type        = string
}

variable "compute_service_account" {
  description = "The Google service account ID."
  type        = string
}

variable "instance_prefix" {
  description = "Name prefix for the instance template"
  type        = string
}

variable "instance_name" {
  description = "Name for the instance template"
  type        = string
}

variable "region" {
  description = "Region where the instance template should be created."
  type        = string
}

variable "can_ip_forward" {
  description = "Enable IP forwarding, for NAT instances for example"
  type        = string
}

variable "disk_size_gb" {
  description = "Boot disk size in GB"
  type        = string
}

variable "disk_type" {
  description = "Boot disk type, can be either pd-ssd, local-ssd, or pd-standard"
  type        = string
}

variable "machine_type" {
  description = "Machine type to create, e.g. n1-standard-1"
  type        = string
}

variable "roles_list" {
  description = "roles list for the service account"
  type        = list(string)
  default     = ["roles/compute.osAdminLogin"]
}

variable "tags" {
  description = "Network tags, provided as a list"
  type        = list(string)
}

variable "network" {
  description = "The name or self_link of the network to attach this interface to. Use network attribute for Legacy or Auto subnetted networks and subnetwork for custom subnetted networks."
  type        = string
}

variable "num_instances" {
  description = "Number of instances to create."
  type        = string
}

variable "source_image" {
  description = "Source disk image. If neither source_image nor source_image_family is specified, defaults to the latest public CentOS image."
  type        = string
}

variable "source_image_project" {
  description = "Source Image Project"
  type        = string
}
variable "source_image_family" {
  description = "Source image family"
  type        = string
}

variable "startup_script" {
  description = "User startup script to run when instances spin up"
  type        = string
}

variable "subnetwork" {
  description = "The name of the subnetwork to attach this interface to. The subnetwork must exist in the same region this instance will be created in. Either network or subnetwork must be provided."
  type        = string
}

variable "metadata" {
  description = "Metadata provided as a map"
  type        = map(string)
  default = {
    serial-port-enable = false,
    enable-oslogin     = true
  }
}

variable "labels" {
  description = "Labels provided as a map"
  type        = map(string)
}

variable "sa_prefix" {
  description = "Name prefix for the service account"
  type        = string
}

variable "access_config" {
  description = "Access configurations, i.e. IPs via which the VM instance can be accessed via the Internet. The networking tier used for configuring this instance. This field can take the following values: PREMIUM or STANDARD."
  type = list(object({
    nat_ip       = string
    network_tier = string
  }))
  default = []
}

variable "zone" {
  type        = string
  description = "Zone where the instances should be created. If not specified, instances will be spread across available zones in the region."
}


/******************************************
  Autoscaling
*****************************************/

variable "autoscaling_name" {
  description = "Name of autoscaling policy"
  type        = string

}

variable "max_replicas" {
  description = "The minimum number of replicas that the autoscaler can scale down to. This cannot be less than 0. If not provided, autoscaler will choose a default value depending on maximum number of instances allowed."
  type        = string
}

variable "min_replicas" {
  description = "The maximum number of instances that the autoscaler can scale up to. This is required when creating or updating an autoscaler. The maximum number of replicas should not be lower than minimal number of replicas."
  type        = string
}


/******************************************
  Instance Group
*****************************************/
variable "instance_group_name" {
  description = "Name of instance group"
  type        = string
}


/******************************************
  KMS
*****************************************/

variable "create_key" {
  description = "If you want to create a key"
  type        = bool
}

variable "disk_encryption_key" {
  description = "The self link of the encryption key that is stored in Google Cloud KMS to use to encrypt all the disks on this instance"
  type        = string
}

variable "use_existing_keyring" {
  description = "If you want to use an existing keyring and don't create a new one -> true"
  type        = bool
}

variable "key_name" {
  description = "Name to be used for KMS Key for CMEK"
  type        = string
}

variable "keyring_name" {
  description = "Name to be used for KMS Keyring for CMEK"
  type        = string
}

variable "key_rotation_period" {
  description = "Rotation period in seconds to be used for KMS Key"
  type        = string
}

variable "prevent_destroy" {
  type        = string
  description = "Prevent bucket key destroy on KMS"
}
