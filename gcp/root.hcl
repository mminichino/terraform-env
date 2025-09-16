locals {
  region_vars         = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  common_vars         = read_terragrunt_config(find_in_parent_folders("common.hcl"))
  gcp_region          = local.region_vars.locals.gcp_region
  gcp_project         = local.common_vars.locals.project
  gcp_credential_file = local.common_vars.locals.credentials
}

remote_state {
  backend = "gcs"
  config = {
    bucket      = "${get_env("TG_BUCKET_PREFIX", "terragrunt")}-terraform-remote-state"
    prefix      = "gcp/${path_relative_to_include()}/terraform.tfstate"
    location    = local.gcp_region
    project     = local.gcp_project
    credentials = local.gcp_credential_file
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}
