locals {
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  env_vars    = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  aws_region  = local.region_vars.locals.aws_region
  stack       = local.env_vars.locals.stack
  tags        = local.env_vars.locals.tags
}

terraform {
  source = "git::git@github.com:mminichino/terraform.git//redis/aws/modules/vpc?ref=v1.0.0"
}

include {
  path = find_in_parent_folders("root.hcl")
}

inputs = {
  name             = local.stack
  aws_region       = local.aws_region
  cidr_block       = "10.55.0.0/16"
  tags             = local.tags
}
