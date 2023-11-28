resource "tls_private_key" "this_privkey" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

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

resource "aws_ebs_volume" "this_ebs" {
  for_each = ["dev", "staging"]

  availability_zone = var.subnet[each.value].availability_zone
  size              = 5
}

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

resource "aws_volume_attachment" "this_attachment" {
  for_each = ["dev", "staging"]

  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.this_ebs[each.value].id
  instance_id = aws_instance.this_instance[each.value].id
}

resource "aws_eip" "bastion_eip" {
  domain    = "vpc"
  instance  = aws_instance.this_instance["bastion"].id
}

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

resource "aws_lb_target_group" "this_tg" {
  for_each = toset(["staging", "dev"])
  name     = "${each.value}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.this_vpc.id
}

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

resource "aws_lb_target_group_attachment" "this_tga" {
  for_each = toset(["staging", "dev"])

  target_group_arn = aws_lb_target_group.this_tg[each.value].arn
  target_id        = aws_instance.this_instance[each.value].id
  port             = 80
}

resource "local_file" "ssh_key" {
  content         = tls_private_key.this_privkey.private_key_pem
  filename        = "${path.module}/ssh_key"
  file_permission = "0400"
}