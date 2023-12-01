# Write ansible_config to local file for future execution of ansible
resource "local_file" "ansible_config" {
  content   = file("${path.module}/includes/ansible_config")
  filename  = "${path.module}/ansible.cfg"

  depends_on = [
    data.template_file.ansible_hosts
  ]
}

# Replace the proxy_dns_name inside ansible_group_vars_all.tpf file for future execution of ansible
# This will include the configuration of the bastion host as a proxy server to connect to the hosts inside the private network
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

# Write ansible group vars locally
resource "local_file" "ansible_group_vars_all" {
  content   = data.template_file.ansible_group_vars_all.rendered
  filename  = "${path.module}/ansible/group_vars/all"

  depends_on = [
    data.template_file.ansible_hosts
  ]
}

# Replace instances IP addresses in ansible hosts file
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

# Write ansible hosts file locally
resource "local_file" "ansible_hosts" {
  content   = data.template_file.ansible_hosts.rendered
  filename  = "${path.module}/ansible/hosts"

  depends_on = [
    data.template_file.ansible_hosts
  ]
}

# Wait for bastion host to be reachable and execute ansible playbook
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