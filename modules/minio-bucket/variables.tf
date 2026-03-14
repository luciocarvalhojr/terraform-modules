variable "bucket_name" {
  description = "Name of the MinIO bucket to create"
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "Bucket name must follow S3 naming rules: lowercase, 3-63 chars, no leading/trailing hyphens."
  }
}

variable "versioning" {
  description = "Enable object versioning (recommended for state buckets)"
  type        = bool
  default     = true
}

variable "noncurrent_version_expiration_days" {
  description = "Days before non-current object versions are deleted. 0 = disabled."
  type        = number
  default     = 90
}
