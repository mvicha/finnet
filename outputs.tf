output "s3_policy_arn" {
  value = aws_iam_policy.s3_tfstate.arn
}

output "s3_bucket_name" {
  value = aws_s3_bucket.s3_tfstate.id
}

output "dynamodb_policy_arn" {
  value = aws_iam_policy.dynamodb_tfstate_lock.arn
}

output "dynamodb_table" {
  value = aws_dynamodb_table.dynamodb-terraform-state-lock.name
}
