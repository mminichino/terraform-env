locals {
  owner       = get_env("LOGNAME", "sa")
  public_key  = get_env("TG_PUBLIC_KEY_FILE", "id_rsa.pub")
  private_key = get_env("TG_PRIVATE_KEY_FILE", "id_rsa")
  ec2_role    = get_env("TG_EC2_INSTANCE_PROFILE", "S3FullAccess")
  redis       = "redislabs-7.22.0-241-jammy-amd64.tar"
  rdi         = "rdi-installation-1.14.0.tar.gz"
  domain      = get_env("TG_DNS_DOMAIN", "cluster.local")
  admin_user  = "admin@redis.com"
}
