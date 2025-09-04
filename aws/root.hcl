locals {
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  aws_region   = local.region_vars.locals.aws_region
}

remote_state {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = "${get_env("TG_BUCKET_PREFIX", "terragrunt")}-terraform-remote-state"
    key            = "aws/${path_relative_to_include()}/terraform.tfstate"
    region         = local.aws_region
    use_lockfile   = true
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}
