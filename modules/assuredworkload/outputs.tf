output "name" {
  description = "assured workloads folder name"
  value       = google_assured_workloads_workload.primary.name
}

output "resources" {
  description = "assured workloads folder name"
  value       = google_assured_workloads_workload.primary.resources
}

output "folder_id" {
  description = "assured workloads folder name"
  value       = google_assured_workloads_workload.primary.resources[1].resource_id
}

output "id" {
  description = "assured workloads folder name"
  value       = google_assured_workloads_workload.primary.id
}