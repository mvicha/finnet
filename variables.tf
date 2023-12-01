variable "env_environment" {
  type        = string
  description = "Variable which holds the environment name"
  default     = ""
}

# Define buckets variable structure
variable "buckets" {
  type = map(object({
      bucket_name = string
    })
  )
}

# Define local variables for account_id and account_arn from data.aws_caller_identity.current in Main.tf
locals {
  account_id    = data.aws_caller_identity.current.account_id
  account_arn   = data.aws_caller_identity.current.arn
}