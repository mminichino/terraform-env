locals {
  region_vars         = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  common_vars         = read_terragrunt_config(find_in_parent_folders("common.hcl"))
  env_vars            = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  gcp_region          = local.region_vars.locals.gcp_region
  gcp_project         = local.common_vars.locals.project
  gcp_credential_file = local.common_vars.locals.credentials
  stack               = local.env_vars.locals.stack
  tags                = local.env_vars.locals.tags
}

terraform {
  source = "git::git@github.com:mminichino/terraform.git//redis/gcp/modules/vpc?ref=v1.0.10"
}

include {
  path = find_in_parent_folders("root.hcl")
}

inputs = {
  name             = local.stack
  gcp_region       = local.gcp_region
  gcp_project_id   = local.gcp_project
  cidr_block       = "10.55.0.0/16"
  credential_file  = local.gcp_credential_file
  tags             = local.tags
}
