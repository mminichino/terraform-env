locals {
  env_vars    = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  common_vars = read_terragrunt_config(find_in_parent_folders("common.hcl"))

  stack = local.env_vars.locals.stack
  tags  = local.env_vars.locals.tags

  ec2_role    = local.common_vars.locals.ec2_role
  public_key  = local.common_vars.locals.public_key

  environment  = "rdbms"
  node_count   = 1
  machine_type = "m5.2xlarge"

  name = join("-", [
    local.stack,
    local.environment
  ])
}

terraform {
  source = "git::git@github.com:mminichino/terraform.git//redis/aws/modules/client?ref=v1.0.0"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    aws_region     = "us-east-2"
    vpc_id         = "vpc-mock123"
    subnet_id_list = ["subnet-mock123", "subnet-mock456", "subnet-mock789"]
    vpc_cidr       = "10.0.0.0/16"
  }

  mock_outputs_allowed_terraform_commands = ["validate", "init"]
}

inputs = {
  name                = local.name
  aws_region          = dependency.vpc.outputs.aws_region
  aws_subnet_id_list  = dependency.vpc.outputs.subnet_id_list
  aws_vpc_cidr        = dependency.vpc.outputs.vpc_cidr
  aws_vpc_id          = dependency.vpc.outputs.vpc_id
  ec2_instance_role   = local.ec2_role
  client_count        = local.node_count
  public_key_file     = local.public_key
  client_machine_type = local.machine_type
  tags                = local.tags
}
