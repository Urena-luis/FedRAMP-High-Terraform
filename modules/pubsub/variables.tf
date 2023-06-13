variable "project_id" {
  type        = string
  description = "The project ID to manage the Pub/Sub resources"
}

variable "location" {
  type        = string
  description = "Region for KMS and PubSub Policy"
}

variable "topic_name" {
  type        = string
  description = "The name for the Pub/Sub topic"
}

variable "create_topic" {
  type        = bool
  description = "Specify true if you want to create a topic"
}

variable "topic_labels" {
  type        = map(string)
  description = "A map of labels to assign to the Pub/Sub topic"
}

variable "subscription_labels" {
  type        = map(string)
  description = "A map of labels to assign to every Pub/Sub subscription"
}

variable "push_subscriptions" {
  type = list(object({
    name                = string
    push_endpoint       = string
    additional_settings = map(string)
  }))
  description = "The list of the push subscriptions"
}

variable "pull_subscriptions" {
  type = list(object({
    name                = string
    additional_settings = map(string)
  }))
  description = "The list of the pull subscriptions"
}

#################################
# KMS Variables
################################

variable "use_existing_keyring" {
  description = "If you want to use an existing keyring and don't create a new one -> true"
  type        = bool
}

variable "keyring_name" {
  description = "Name to be used for KMS Keyring for CMEK"
  type        = string
}

variable "cmek_project_id" {
  description = "assured workloads cmek project id"
  type        = string
}
