locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("common.hcl"))
  private_key = local.common_vars.locals.private_key
}

terraform {
  source = "git::git@github.com:mminichino/terraform.git//redis/aws/modules/database?ref=v1.0.7"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

dependency "redis" {
  config_path = "../../redis"

  mock_outputs = {
    password               = "password"
    admin_user             = "admin@redis.io"
    primary_node_public_ip = "1.2.3.4"
  }

  mock_outputs_allowed_terraform_commands = ["validate", "init"]
}

inputs = {
  uid              = 3
  name             = "rdidb"
  port             = 12003
  replication      = true
  memory_size      = 268435456
  password         = dependency.redis.outputs.password
  username         = dependency.redis.outputs.admin_user
  private_key_file = local.private_key
  public_ip        = dependency.redis.outputs.primary_node_public_ip
}
