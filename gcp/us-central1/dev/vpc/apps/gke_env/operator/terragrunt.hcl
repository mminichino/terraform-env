#

terraform {
  source = "git::git@github.com:mminichino/terraform.git//redis/gcp/modules/operator?ref=v1.0.22"
}

include "gke" {
  path = find_in_parent_folders("gke.hcl")
}
