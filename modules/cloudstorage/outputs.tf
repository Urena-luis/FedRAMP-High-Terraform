output "bucket" {
  description = "Bucket resource (for single use)."
  value       = module.gcs_buckets.bucket
}

output "name" {
  description = "Bucket name (for single use)."
  value       = module.gcs_buckets.name
}

output "url" {
  description = "Bucket URL (for single use)."
  value       = module.gcs_buckets.url
}

output "buckets" {
  description = "Bucket resources as list."
  value       = module.gcs_buckets.buckets
}

output "names" {
  description = "Bucket names."
  value       = module.gcs_buckets.names
}

output "urls" {
  description = "Bucket URLs."
  value       = module.gcs_buckets.urls
}

output "names_list" {
  description = "List of bucket names."
  value       = module.gcs_buckets.names_list
}

output "urls_list" {
  description = "List of bucket URLs."
  value       = module.gcs_buckets.urls_list
}
