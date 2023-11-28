variable "bucket_name" {
  type        = string
  description = "Variable which holds auth_bucket descriptive bucket name"
  default     = ""
}

variable "environment" {
  type        = string
  description = "Variable which holds the environment value"
  default     = ""
}

variable "service_name" {
  type        = string
  description = "Variable which holds the service name"
  default     = ""
}

variable "kms_arn" {
  type        = string
  description = "KMS key arn"
  default     = ""
}

locals {
  modvar_bucket = lower("${substr(random_id.s3_random.hex, 0, 8)}-${var.bucket_name}-${var.environment}")
  index_vars = {
    site = var.service_name
    env = var.environment
  }
}