# locals {
#   ansible_data = flatten([
#     for instance_name, instance_value in aws_instance.this_instance : {
#       name        = instance_name
#       private_ip  = instance_value.private_ip
#       dns_name    = instance_value.public_dns
#     }
#   ])
# }

resource "local_file" "ansible_config" {
  content   = file("${path.module}/includes/ansible_config")
  filename  = "${path.module}/ansible.cfg"

  depends_on = [
    data.template_file.ansible_hosts
  ]
}

data "template_file" "ansible_group_vars_all" {
  template = file("${path.module}/includes/ansible_group_vars_all.tpl")

  vars = {
    proxy_dns_name  = aws_eip.bastion_eip.public_dns
  }

  depends_on = [ 
    aws_instance.this_instance["bastion"],
    aws_eip.bastion_eip
  ]
}

resource "local_file" "ansible_group_vars_all" {
  content   = data.template_file.ansible_group_vars_all.rendered
  filename  = "${path.module}/ansible/group_vars/all"

  depends_on = [
    data.template_file.ansible_hosts
  ]
}

data "template_file" "ansible_hosts" {
  template = file("${path.module}/includes/ansible_hosts.tpl")

  vars = {
    instance_dev      = aws_instance.this_instance["dev"].private_ip
    instance_staging  = aws_instance.this_instance["staging"].private_ip
  }

  depends_on = [ 
    aws_instance.this_instance["dev"],
    aws_instance.this_instance["staging"]
  ]
}

resource "local_file" "ansible_hosts" {
  content   = data.template_file.ansible_hosts.rendered
  filename  = "${path.module}/ansible/hosts"

  depends_on = [
    data.template_file.ansible_hosts
  ]
}

resource "terraform_data" "ansible" {
  provisioner "remote-exec" {
    connection {
      host = aws_eip.bastion_eip.public_dns
      user = "ubuntu"
      private_key = tls_private_key.this_privkey.private_key_pem
    }

    inline = ["echo 'connected!'"]
  }

  provisioner "local-exec" {
    command = "ansible-playbook -e var_ssh_key=ssh_key -u ubuntu ansible/playbooks/initialize.yml"
  }

  depends_on = [
    aws_instance.this_instance["bastion"],
    aws_instance.this_instance["dev"],
    aws_instance.this_instance["staging"],
    aws_eip.bastion_eip
  ]
}