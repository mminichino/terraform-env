locals {
  name = "redb1"
}

terraform {
  source = "git::git@github.com:mminichino/terraform.git//redis/gcp/modules/redb?ref=v1.0.30"
}

include "gke" {
  path = find_in_parent_folders("gke.hcl")
}

dependency "gke_env" {
  config_path = "../../../../gke_env"

  mock_outputs = {
    nginx_ingress_ip = "1.2.3.4"
    gke_domain_name  = "usz1-mock"
  }

  mock_outputs_allowed_terraform_commands = ["validate", "init"]
}

dependency "rec" {
  config_path = "../../rec"

  mock_outputs = {
    namespace       = "redis"
    cluster         = "redis-enterprise-cluster"
    ingress_enabled = true
  }

  mock_outputs_allowed_terraform_commands = ["validate", "init", "plan"]
}

inputs = {
  name             = local.name
  domain_name      = dependency.gke_env.outputs.gke_domain_name
  nginx_ingress_ip = dependency.gke_env.outputs.nginx_ingress_ip
  namespace        = dependency.rec.outputs.namespace
  cluster          = dependency.rec.outputs.cluster
  ingress_enabled  = dependency.rec.outputs.ingress_enabled
}
