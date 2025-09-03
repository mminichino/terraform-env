# AWS region variables
locals {
  aws_region       = "us-east-2"
  aws_short_region = "use2"

  region_tags = {
    AWSRegion      = local.aws_region
    AWSShortRegion = local.aws_short_region
  }

  tags = local.region_tags
}
