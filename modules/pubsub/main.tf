resource "random_string" "random_key" {
  length  = 5
  special = false
  lower   = true
  upper   = false
  number  = true
}

data "google_project" "project" {
  project_id = var.project_id
}

module "kms" {
  count  = 1
  source = "../kms/"
  #project_id           = var.project_id
  cmek_project_id      = var.cmek_project_id
  use_existing_keyring = var.use_existing_keyring
  keyring              = var.keyring_name
  location             = var.location
  keys                 = ["pubsub-${var.topic_name}-key"]
  key_rotation_period  = "7776000s"
  encrypters           = ["serviceAccount:service-${data.google_project.project.number}@gcp-sa-pubsub.iam.gserviceaccount.com"]
  set_encrypters_for   = ["pubsub-${var.topic_name}-key"]
  decrypters           = ["serviceAccount:service-${data.google_project.project.number}@gcp-sa-pubsub.iam.gserviceaccount.com"]
  set_decrypters_for   = ["pubsub-${var.topic_name}-key"]
  prevent_destroy      = false
}

resource "google_pubsub_topic" "existing_topic" {
  count   = var.create_topic ? 0 : 1
  name    = var.topic_name
  project = var.project_id
}

module "pubsub" {
  source               = "terraform-google-modules/pubsub/google"
  version              = "~> 3.0"
  project_id           = var.project_id
  topic                = var.topic_name
  create_topic         = true
  create_subscriptions = length(var.push_subscriptions) == 0 && length(var.pull_subscriptions) == 0 ? false : true
  topic_kms_key_name   = module.kms[0].keys["pubsub-${var.topic_name}-key"]
  message_storage_policy = {
    allowed_persistence_regions = [var.location]
  }
  push_subscriptions = [for sub in var.push_subscriptions :
    {
      name                       = sub.name
      push_endpoint              = sub.push_endpoint
      x-goog-version             = "v1beta1"
      oidc_service_account_email = lookup(sub.additional_settings, "oidc_service_account_email", "serviceAccount:service-${data.google_project.project.number}@gcp-sa-pubsub.iam.gserviceaccount.com")
      audience                   = lookup(sub.additional_settings, "audience", null)
      expiration_policy          = lookup(sub.additional_settings, "expiration_policy", "3000000s")
      dead_letter_topic          = lookup(sub.additional_settings, "dead_letter_topic", "projects/${var.project_id}/topics/${var.topic_name}")
      max_delivery_attempts      = lookup(sub.additional_settings, "max_delivery_attempts", null)
      maximum_backoff            = lookup(sub.additional_settings, "maximum_backoff", null)
      minimum_backoff            = lookup(sub.additional_settings, "minimum_backoff", null)
      filter                     = lookup(sub.additional_settings, "filter", null)
      enable_message_ordering    = lookup(sub.additional_settings, "enable_message_ordering", true)
      message_retention_duration = lookup(sub.additional_settings, "message_retention_duration", null)
      retain_acked_messages      = lookup(sub.additional_settings, "retain_acked_messages", false)
    }
  ]
  pull_subscriptions = [for sub in var.pull_subscriptions :
    {
      name                    = sub.name
      ack_deadline_seconds    = lookup(sub.additional_settings, "ack_deadline_seconds", null)
      dead_letter_topic       = lookup(sub.additional_settings, "dead_letter_topic", "projects/${var.project_id}/topics/${var.topic_name}")
      max_delivery_attempts   = lookup(sub.additional_settings, "max_delivery_attempts", null)
      maximum_backoff         = lookup(sub.additional_settings, "maximum_backoff", null)
      minimum_backoff         = lookup(sub.additional_settings, "minimum_backoff", null)
      filter                  = lookup(sub.additional_settings, "filter", null)
      enable_message_ordering = lookup(sub.additional_settings, "enable_message_ordering", true)
      service_account         = lookup(sub.additional_settings, "service_account", null)
    }
  ]
  topic_labels        = var.topic_labels
  subscription_labels = var.subscription_labels
}
