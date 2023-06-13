output "project_id" {
  value       = var.project_id
  description = "The project ID"
}

output "topic_name" {
  value       = module.pubsub.topic
  description = "The name of the Pub/Sub topic created"
}

output "topic_labels" {
  value       = module.pubsub.topic_labels
  description = "The labels of the Pub/Sub topic created"
}

output "subscription_path" {
  value       = module.pubsub.subscription_paths
  description = "The labels of the Pub/Sub topic created"
}

output "subscription_name" {
  value       = module.pubsub.subscription_names
  description = "The labels of the Pub/Sub topic created"
}

output "pubsub_id" {
  value       = module.pubsub.id
  description = "Pubsub id"
}
