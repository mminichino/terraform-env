locals {
  root_dir    = dirname(find_in_parent_folders("root.hcl"))
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  common_vars = read_terragrunt_config(find_in_parent_folders("common.hcl"))

  gcp_region          = local.region_vars.locals.gcp_region
  gcp_project         = local.common_vars.locals.project
  gcp_credential_file = local.common_vars.locals.credentials
  gke_path            = "${local.root_dir}/${local.gcp_region}/dev/vpc/gke"
}

dependency "gke" {
  config_path = local.gke_path

  mock_outputs = {
    cluster_endpoint_url   = "https://gke.cluster.com"
    access_token           = "token"
    cluster_ca_certificate = "cert"
  }
  mock_outputs_allowed_terraform_commands = ["init", "plan", "validate", "graph"]
}

generate "providers" {
  path      = "providers.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<-EOT
    provider "google" {
      credentials = file("${local.gcp_credential_file}")
      project     = "${local.gcp_project}"
      region      = "${local.gcp_region}"
    }

    provider "kubernetes" {
      host                   = "${dependency.gke.outputs.cluster_endpoint_url}"
      token                  = "${dependency.gke.outputs.access_token}"
      cluster_ca_certificate = <<CERT
${dependency.gke.outputs.cluster_ca_certificate}
CERT
    }

    provider "helm" {
      kubernetes = {
        host                   = "${dependency.gke.outputs.cluster_endpoint_url}"
        token                  = "${dependency.gke.outputs.access_token}"
        cluster_ca_certificate = <<CERT
${dependency.gke.outputs.cluster_ca_certificate}
CERT
      }
    }
  EOT
}

remote_state {
  backend = "gcs"
  config = {
    bucket      = "${get_env("TG_BUCKET_PREFIX", "terragrunt")}-terraform-remote-state"
    prefix      = "gcp/${path_relative_to_include()}/terraform.tfstate"
    location    = local.gcp_region
    project     = local.gcp_project
    credentials = local.gcp_credential_file
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}
