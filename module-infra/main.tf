resource "aws_security_group" "tool" {
  name        = "${var.name}-sg"
  description = "${var.name} Security Group"

  tags = {
    Name = "${var.name}-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.tool.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
  description       = "ssh"
}

resource "aws_vpc_security_group_ingress_rule" "app_port" {
  for_each          = var.ports
  security_group_id = aws_security_group.tool.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = each.value
  ip_protocol       = "tcp"
  to_port           = each.value
  description       = each.key
}

resource "aws_vpc_security_group_egress_rule" "egress_allow_all" {
  security_group_id = aws_security_group.tool.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_instance" "tool" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.tool.id]
  iam_instance_profile   = aws_iam_instance_profile.main.name

  tags = {
    Name = var.name
  }
}

resource "aws_route53_record" "private" {
  zone_id = var.zone_id
  name    = "${var.name}-internal"
  type    = "A"
  ttl     = 10
  records = [aws_instance.tool.private_ip]
}


resource "aws_route53_record" "public" {
  zone_id = var.zone_id
  name    = var.name
  type    = "A"
  ttl     = 10
  records = [aws_instance.tool.public_ip]
}

