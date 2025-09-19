#

terraform {
  source = "git::git@github.com:mminichino/terraform.git//redis/gcp/modules/gke_env?ref=v1.0.22"
}

include "gke" {
  path = find_in_parent_folders("gke.hcl")
}

dependency "gke" {
  config_path = "../../gke"

  mock_outputs = {
    cluster_domain = "usz1-mock"
    storage_class  = "standard"
  }

  mock_outputs_allowed_terraform_commands = ["validate", "init", "plan"]
}

inputs = {
  gke_domain_name   = dependency.gke.outputs.cluster_domain
  gke_storage_class = dependency.gke.outputs.storage_class
}
