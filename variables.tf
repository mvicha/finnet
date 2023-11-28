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