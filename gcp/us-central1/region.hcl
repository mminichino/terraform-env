# GCP region variables
locals {
  gcp_region       = "us-central1"
  gcp_short_region = "usc1"

  region_tags = {
    gcp_region       = local.gcp_region
    gcp_short_region = local.gcp_short_region
  }

  tags = local.region_tags
}
