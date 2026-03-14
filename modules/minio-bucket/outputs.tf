output "bucket_name" {
  description = "Name of the created bucket"
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "ARN of the created bucket"
  value       = aws_s3_bucket.this.arn
}

output "versioning_enabled" {
  description = "Whether versioning is enabled on the bucket"
  value       = var.versioning
}
