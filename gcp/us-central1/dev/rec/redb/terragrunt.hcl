#
locals {
  name = "redb1"
}

terraform {
  source = "git::git@github.com:mminichino/terraform.git//redis/gcp/modules/redb?ref=v1.0.15"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

dependency "gke" {
  config_path = "../../gke"

  mock_outputs = {
    cluster_ca_certificate = "usz1-mock-subnet"
    cluster_domain         = "usz1-mock"
    cluster_endpoint_url   = "https://gke.cluster.com"
    access_token           = "token"
    storage_class          = "standard"
  }

  mock_outputs_allowed_terraform_commands = ["validate", "init"]
}

dependency "rec" {
  config_path = "../../rec"

  mock_outputs = {
    cluster = "redis-enterprise-cluster"
  }

  mock_outputs_allowed_terraform_commands = ["validate", "init", "plan"]
}

inputs = {
  cluster_ca_certificate = dependency.gke.outputs.cluster_ca_certificate
  domain_name            = dependency.gke.outputs.cluster_domain
  kubernetes_endpoint    = dependency.gke.outputs.cluster_endpoint_url
  kubernetes_token       = dependency.gke.outputs.access_token
  cluster                = dependency.rec.outputs.cluster
  name                   = local.name
}
