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
  type    = string
  default = ""
}

variable "buckets" {
  type = map(object({
    bucket_arn = string
    bucket_domain_name = string
    bucket_name = string
  }))
}

variable "oac_id" {
  type = string
  default = ""
}

locals {
  account_id          = data.aws_caller_identity.current.account_id
  account_arn         = data.aws_caller_identity.current.arn
  s3_origin_id        = "${var.environment}${var.service_name}"
}