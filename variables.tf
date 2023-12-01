# variable "bucket_name" {
#   type        = string
#   description = "Variable which holds the S3 bucket name"
#   default     = ""
# }

variable "environment" {
  type        = string
  description = "Variable which holds the environment name"
  default     = ""
}

variable "service_name" {
  type        = string
  description = "Variable which holds the service name"
  default     = ""
}

variable "logging_bucket" {
  type        = string
  default     = ""
  description = "Name of the bucket used for CloudFront logging"
}

variable "buckets" {
  type        = map(object({
    bucket_arn          = string
    bucket_domain_name  = string
    bucket_name         = string
  }))
  description = "Buckets that were created with s3 Module to serve auth, info and customers content"
}

variable "oac_id" {
  type        = string
  default     = ""
  description = "Origin Access Control ID to allow signing URLs"
}

# Create local variables for usage in different sections of this module
locals {
  account_id          = data.aws_caller_identity.current.account_id
  account_arn         = data.aws_caller_identity.current.arn
  s3_origin_id        = "${var.environment}${var.service_name}"
}