module "terraform_state" {
  source = "../../modules/minio-bucket"

  bucket_name                        = "terraform-state"
  versioning                         = true
  noncurrent_version_expiration_days = 90
}

module "backups" {
  source = "../../modules/minio-bucket"

  bucket_name                        = "homelab-backups"
  versioning                         = true
  noncurrent_version_expiration_days = 30
}

output "state_bucket" {
  value = module.terraform_state.bucket_name
}
