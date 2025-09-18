#

terraform {
  source = "git::git@github.com:mminichino/terraform.git//redis/gcp/modules/operator?ref=v1.0.14"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

dependency "gke" {
  config_path = "../gke"

  mock_outputs = {
    cluster_ca_certificate = "usz1-mock-subnet"
    cluster_endpoint_url   = "https://gke.cluster.com"
    access_token           = "token"
  }

  mock_outputs_allowed_terraform_commands = ["validate", "init"]
}

inputs = {
  cluster_ca_certificate = dependency.gke.outputs.cluster_ca_certificate
  kubernetes_endpoint    = dependency.gke.outputs.cluster_endpoint_url
  kubernetes_token       = dependency.gke.outputs.access_token
}
