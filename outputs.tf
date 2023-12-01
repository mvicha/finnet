output "SSH_Key" {
  value     = tls_private_key.this_privkey.private_key_pem
  description = "SSH Private Key value"
  sensitive = true
}

output "BastionHostDNS" {
  value       = aws_eip.bastion_eip.public_dns
  description = "Public DNS address of the Bastion Host"
}

output "BastionHostIP" {
  value       = aws_eip.bastion_eip.public_ip
  description = "Public IP address of the Bastion Host"
}

output "BastionInstanceId" {
  value       = aws_instance.this_instance["bastion"].id
  description = "Instance ID of the Bastion Host"
}

output "DevHost" {
  value       = aws_instance.this_instance["dev"].private_ip
  description = "Private IP address of the Dev Host"
}

output "DevHostInstanceId" {
  value       = aws_instance.this_instance["dev"].id
  description = "Instance ID of the Dev Host"
}

output "StagingHost" {
  value       = aws_instance.this_instance["staging"].private_ip
  description = "Private IP address of the Staging Host"
}

output "StagingHostInstanceId" {
  value       = aws_instance.this_instance["staging"].id
  description = "Instance ID of the Staging Host"
}

output "lb_dev" {
  value       = join("", ["http://", aws_alb.this_alb["dev"].dns_name])
  description = "URL for Dev Load Balancer"
}

output "lb_staging" {
  value       = join("", ["http://", aws_alb.this_alb["staging"].dns_name])
  description = "URL for Staging Load Balancer"
}