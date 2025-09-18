locals {
  env_vars    = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  common_vars = read_terragrunt_config(find_in_parent_folders("common.hcl"))
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  stack = local.env_vars.locals.stack
  tags  = local.env_vars.locals.tags

  gcp_project         = local.common_vars.locals.project
  gcp_credential_file = local.common_vars.locals.credentials
  gcp_region          = local.region_vars.locals.gcp_region

  node_count    = 1
  machine_type  = "n2-standard-8"
  gcp_zone_name = get_env("TG_GKE_ZONE_NAME", "gke-domain")
}

terraform {
  source = "git::git@github.com:mminichino/terraform.git//redis/gcp/modules/gke?ref=v1.0.13"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    subnet_name = "usz1-mock-subnet"
    vpc_name    = "usz1-mock"
  }

  mock_outputs_allowed_terraform_commands = ["validate", "init", "plan"]
}

inputs = {
  name            = local.stack
  credential_file = local.gcp_credential_file
  gcp_project_id  = local.gcp_project
  gcp_region      = local.gcp_region
  node_count      = local.node_count
  machine_type    = local.machine_type
  network_name    = dependency.vpc.outputs.vpc_name
  subnet_name     = dependency.vpc.outputs.subnet_name
  gcp_zone_name   = local.gcp_zone_name
  labels          = local.tags
}
