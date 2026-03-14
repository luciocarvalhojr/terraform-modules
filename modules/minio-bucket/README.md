# module: minio-bucket

Creates a MinIO bucket using the AWS provider pointed at a MinIO S3-compatible endpoint. Supports versioning and automatic noncurrent version expiration.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.9.0 |
| hashicorp/aws | ~> 5.0 |

## Provider configuration

```hcl
provider "aws" {
  endpoints {
    s3 = "http://192.168.0.95:9000"
  }
  access_key                  = var.minio_access_key
  secret_key                  = var.minio_secret_key
  region                      = "us-east-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `bucket_name` | Bucket name (S3 naming rules) | `string` | — | yes |
| `versioning` | Enable object versioning | `bool` | `true` | no |
| `noncurrent_version_expiration_days` | Days to retain old versions (0 = disabled) | `number` | `90` | no |

## Outputs

| Name | Description |
|------|-------------|
| `bucket_name` | Name of the created bucket |
| `bucket_arn` | ARN of the created bucket |
| `versioning_enabled` | Whether versioning is enabled |

## Example

See [`examples/minio-bucket/`](../../examples/minio-bucket/main.tf).
