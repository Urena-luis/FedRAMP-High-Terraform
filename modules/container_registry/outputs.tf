output "bucket_name" {
  description = "Name of bucket that backs the container registry"
  value       = google_container_registry.ml-registry.id
}