output "SSH_Key" {
  value     = tls_private_key.this_privkey.private_key_pem
  sensitive = true
}

output "BastionHostDNS" {
  value = aws_eip.bastion_eip.public_dns
}

output "BastionHostIP" {
  value = aws_eip.bastion_eip.public_ip
}

output "BastionInstanceId" {
  value = aws_instance.this_instance["bastion"].id
}

output "DevHost" {
  value = aws_instance.this_instance["dev"].private_ip
}

output "DevHostInstanceId" {
  value = aws_instance.this_instance["dev"].id
}

output "StagingHost" {
  value = aws_instance.this_instance["staging"].private_ip
}

output "StagingHostInstanceId" {
  value = aws_instance.this_instance["staging"].id
}

output "lb_dev" {
  value = join("", ["http://", aws_alb.this_alb["dev"].dns_name])
}

output "lb_staging" {
  value = join("", ["http://", aws_alb.this_alb["staging"].dns_name])
}

# locals {
#   thisoutput = flatten([
#     for instance_name, instance_value in aws_instance.this_instance : {
#       name        = instance_name
#       private_ip  = instance_value.private_ip
#       dns_name    = instance_value.public_dns
#     }
#   ])
# }

# output "test" {
#   value = local.thisoutput
# }