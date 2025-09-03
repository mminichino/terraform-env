locals {
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  aws_region   = local.region_vars.locals.aws_region
}

remote_state {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = "terraform-state-${get_env("TG_AWS_ACCOUNT_NUMBER", "")}-us-east-2"
    key            = "aws/${path_relative_to_include()}/terraform.tfstate"
    region         = local.aws_region
    use_lockfile   = true
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}
