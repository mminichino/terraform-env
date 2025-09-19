#

terraform {
  source = "git::git@github.com:mminichino/terraform.git//redis/gcp/modules/rec?ref=v1.0.22"
}

include "gke" {
  path = find_in_parent_folders("gke.hcl")
}

dependency "gke_env" {
  config_path = "../../../gke_env"

  mock_outputs = {
    gke_domain_name   = "usz1-mock"
    gke_storage_class = "standard"
  }

  mock_outputs_allowed_terraform_commands = ["validate", "init", "plan"]
}

inputs = {
  domain_name   = dependency.gke_env.outputs.gke_domain_name
  storage_class = dependency.gke_env.outputs.gke_storage_class
}
