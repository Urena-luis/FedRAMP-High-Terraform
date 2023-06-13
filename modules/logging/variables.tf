variable "project_id" {
  description = "Project id where the logging sink is created."
  type        = string
}

variable "log_sink_name" {
  description = "Name of the log sink"
  type        = string
  default     = "logsinkfedramp"
}


variable "log_filters" {
  description = "Log filters tobe applied"
  type        = string
  default     = ""
}

variable "sink_destination" {
  description = "Sink destination"
  type        = string
  default     = ""
}

# variable "unique_writer_identity" {
#   description = "unique_writer_identity"
#   type        = bool
# }


# variable "sinks" {
#   description = "logging sinks settings"
#   type = map(object({
#     name                   = string
#     destination            = string
#     filter                 = string
#     unique_writer_identity = bool
#   }))
# }

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
# }

