terraform {
  backend "gcs" {
    bucket = "UPDATE_BUCKET_NAME"
    prefix = "terraform/fh/state"
  }
}
