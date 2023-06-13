module "gcloud" {
  source           = "terraform-google-modules/gcloud/google"
  version          = "~> 2.0"
  platform         = "linux"
  create_cmd_body  = "beta projects move ${var.project_id} --folder  ${var.aw_parent_id}"
  destroy_cmd_body = "beta projects move ${var.project_id} --organization ${var.organization_id}"
}