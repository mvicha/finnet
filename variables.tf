variable "s3_tfstate" {
  type        = string
  description = "This variable holds the value of the S3 bucket where remote tfstate is going to be stored"
  default     = "mfvilla-tfstate"
}

variable "dynamodb_tfstate_lock" {
  type        = string
  description = "This variable holds the value of the DynamoDB table name used to lock state"
  default     = "terraform-state-lock-dynamo"
}

# Save current user variable to use with policy documents
locals {
  user_name = regex(".*[:/](.*)$", data.aws_caller_identity.current.arn)[0]
}