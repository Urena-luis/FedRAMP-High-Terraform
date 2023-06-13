resource "google_logging_project_sink" "logging_sink" {
  #for_each               = var.sinks
  project                = var.project_id
  name                   = var.log_sink_name
  destination            = var.sink_destination
  filter                 = var.log_filters
  unique_writer_identity = true
}

resource "google_project_iam_binding" "log-writer" {
  project = var.project_id
  role    = "roles/pubsub.publisher"
  members = [
    google_logging_project_sink.logging_sink.writer_identity,
  ]
}

resource "google_project_iam_audit_config" "logging_project" {
  project = var.project_id
  service = "allServices"
  audit_log_config {
    log_type = "ADMIN_READ"
  }

  audit_log_config {
    log_type = "DATA_READ"
  }

  audit_log_config {
    log_type = "DATA_WRITE"
  }
}

# resource "google_monitoring_alert_policy" "monitoring_alert" {
#   for_each     = var.monitoring_alerts
#   display_name = each.value["display_name"]
#   combiner     = each.value["combiner"]
#   conditions {
#     display_name = each.value.display_name_condition
#     condition_threshold {
#       filter     = each.value.filter
#       duration   = each.value.duration
#       comparison = each.value.comparison
#       aggregations {
#         alignment_period   = each.value.alignment_period
#         per_series_aligner = each.value.per_series_aligner
#       }
#     }
#   }
# }
