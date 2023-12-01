# Create a private key for creating an ssh key pair to connect to the remote hosts
resource "tls_private_key" "this_privkey" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create an SSH key pair for connecting to the remote hosts
resource "aws_key_pair" "this_kp" {
  key_name   = "ec2kp"
  public_key = tls_private_key.this_privkey.public_key_openssh
}


data "template_file" "ssh_priv_key" {
  template = file("${path.module}/includes/user_data.tpl")

  for_each = var.instances
  vars = {
    tls_key         = tls_private_key.this_privkey.private_key_pem
    instance_name   = each.key
  }
}

# Create an ebs volume of 5 Gb for hosts dev and staging to use as persistent volume
resource "aws_ebs_volume" "this_ebs" {
  for_each = toset(["dev", "staging"])

  availability_zone = var.subnet[each.value].availability_zone
  size              = 5
}

# Create bastion, dev and staging ec2 instances
# Take variables ami_id and instance_type from env/dev.tfvars instances variable
resource "aws_instance" "this_instance" {
  for_each = var.instances

  ami                     = var.ami_id
  instance_type           = each.value.instance_type
  key_name                = aws_key_pair.this_kp.key_name
  subnet_id               = aws_subnet.this_subnet[each.value.subnet].id
  vpc_security_group_ids  = [aws_security_group.this_sg.id]
  user_data               = each.value.user_data ? data.template_file.ssh_priv_key[each.key].rendered : ""

  tags = {
    Name  = each.key
    Type  = "Instance"
  }
}

# Attache previously generated ebs volume to /dev/sdh. When inside the instances, this is going to be named /dev/xvdh
resource "aws_volume_attachment" "this_attachment" {
  for_each = toset(["dev", "staging"])

  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.this_ebs[each.value].id
  instance_id = aws_instance.this_instance[each.value].id
}

# Create a new Elastic IP for Bastion Host
resource "aws_eip" "bastion_eip" {
  domain    = "vpc"
  instance  = aws_instance.this_instance["bastion"].id
}

# Create an Application Load Balancer for dev and staging
# internal is false because the LoadBalancer needs to connect Internet to our Private IPs
# subnets are public, because the LoadBalancer needs to run facing Internet. There's a route table entry for local traffic for the subnet which is going to connect this subnet to the private one
resource "aws_alb" "this_alb" {
  for_each = toset(["staging", "dev"])

  name                        = "${each.value}-lb"
  internal                    = false
  load_balancer_type          = "application"
  security_groups             = [aws_security_group.this_sg.id]
  subnets                     = [aws_subnet.this_subnet["${each.value}_pub"].id, aws_subnet.this_subnet["${each.value}_pub2"].id]
  # enable_deletion_protection  = each.value == "dev" ? false : true
  enable_deletion_protection  = false

  tags = {
    Name  = "${each.value} LB"
    Env   = "${each.value}"
  }
}

# Create a Target Group to connect port 80 to our Instances
resource "aws_lb_target_group" "this_tg" {
  for_each = toset(["staging", "dev"])
  name     = "${each.value}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.this_vpc.id
}

# Create a Listener for port 80 connections and forward it to the Target Group
resource "aws_lb_listener" "this_lbl" {
  for_each = toset(["staging", "dev"])

  load_balancer_arn = aws_alb.this_alb[each.value].arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this_tg[each.value].arn
  }
}

# Associate the Target Group to the instance
resource "aws_lb_target_group_attachment" "this_tga" {
  for_each = toset(["staging", "dev"])

  target_group_arn = aws_lb_target_group.this_tg[each.value].arn
  target_id        = aws_instance.this_instance[each.value].id
  port             = 80
}

# Write the private SSH key file contents into a local file named ssh_key
resource "local_file" "ssh_key" {
  content         = tls_private_key.this_privkey.private_key_pem
  filename        = "${path.module}/ssh_key"
  file_permission = "0400"
}
