output "kms" {
  value       = data.template_file.kms_default_policy.rendered
  description = "Display generated KMS policy"
}