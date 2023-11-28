output "bucket_name" {
  value = aws_s3_bucket.mod_bucket.bucket
  description = "Bucket Name"
}

output "bucket_arn" {
  value = aws_s3_bucket.mod_bucket.arn
  description = "Bucket arn"
}

output "bucket_domain_name" {
  value = aws_s3_bucket.mod_bucket.bucket_domain_name
  description = "Bucket Domain Name"
}