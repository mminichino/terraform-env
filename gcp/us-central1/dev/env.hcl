locals {
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  common_vars      = read_terragrunt_config(find_in_parent_folders("common.hcl"))

  gcp_short_region = local.region_vars.locals.gcp_short_region

  owner = local.common_vars.locals.owner

  environment = "dev"

  stack = join("-", [
    local.gcp_short_region,
    local.environment
  ])

  env_tags = {
    stack                = local.stack
    environment          = local.environment
    owner                = local.owner
  }

  tags = local.env_tags
}
