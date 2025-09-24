#
locals {
  namespace = "redis"
  version   = "7.22.0-17"
}

terraform {
  source = "git::git@github.com:mminichino/terraform.git//redis/gcp/modules/operator?ref=v1.0.26"
}

include "gke" {
  path = find_in_parent_folders("gke.hcl")
}

inputs = {
  namespace        = local.namespace
  operator_version = local.version
}
