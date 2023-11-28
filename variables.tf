variable "env_environment" {
  type        = string
  description = "Variable which holds the environment name"
  default     = ""
}

variable "buckets" {
  type = map(object({
      bucket_name = string
    })
  )
}

locals {
  account_id    = data.aws_caller_identity.current.account_id
  account_arn   = data.aws_caller_identity.current.arn
}