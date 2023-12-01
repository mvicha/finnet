output "s3_policy_arn" {
  value       = aws_iam_policy.s3_tfstate.arn
  description = "Arn for the Terraform States S3 Bucket"
}

# Required for other Terraform executions
output "s3_bucket_name" {
  value       = aws_s3_bucket.s3_tfstate.id
  description = "Name of the Terraform States S3 Bucket"
}

output "dynamodb_policy_arn" {
  value       = aws_iam_policy.dynamodb_tfstate_lock.arn
  description = "Arn for the DynamoDB Table for locking purposes"
}

# Required for other Terraform executions
output "dynamodb_table" {
  value       = aws_dynamodb_table.dynamodb-terraform-state-lock.name
  description = "Name of the DynanmoDB Table"
}
