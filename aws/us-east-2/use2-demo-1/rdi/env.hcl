locals {
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  common_vars      = read_terragrunt_config(find_in_parent_folders("common.hcl"))

  aws_short_region = local.region_vars.locals.aws_short_region

  owner = local.common_vars.locals.owner

  environment = "rdi"

  stack = join("-", [
    local.aws_short_region,
    local.environment
  ])

  env_tags = {
    Stack                = local.stack
    Environment          = local.environment
    Owner                = local.owner
  }

  tags = local.env_tags
}
