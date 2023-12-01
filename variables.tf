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

variable "cloudfront_id" {
  type        = string
  default     = ""
  description = "CloudFront distribution ID"
}

variable "buckets" {
  type                  = map(object({
    bucket_arn          = string
    bucket_domain_name  = string
    bucket_name         = string
  }))
  description = "Variable containing the auth, info and customers bucket information"
}

# Define local variables that are going to be used in different sections of the process
locals {
  account_id      = data.aws_caller_identity.current.account_id
  account_arn     = data.aws_caller_identity.current.arn
  cloudfront_arn  = data.aws_cloudfront_distribution.selected.arn
}