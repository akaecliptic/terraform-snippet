// app ec2 instance security groups:
// ingress - bound, main application port
// egress - all traffic
resource "aws_security_group" "app_security_ec2" {
  name        = "${var.app_name}-security-ec2"
  vpc_id      = data.aws_vpc.app_vpc.id
  description = "${var.app_name} ec2 security group"

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    description      = "Allow all egress traffic"
  }

  ingress = [
    {
      from_port        = var.app_ingress_port
      to_port          = var.app_ingress_port
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      self             = false
      prefix_list_ids  = []
      security_groups  = []
      description      = "Allow ingress traffic on main application port"
    },
  ]

  tags = {
    Name = "${var.app_name}-security-ec2"
  }
}

// app alb security groups:
// ingress - standard http and https ports
// egress - all traffic
resource "aws_security_group" "app_security_alb" {
  name        = "${var.app_name}-security-alb"
  vpc_id      = data.aws_vpc.app_vpc.id
  description = "${var.app_name} alb security group"

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    description      = "Allow all egress traffic"
  }

  ingress = [
    {
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      self             = false
      prefix_list_ids  = []
      security_groups  = []
      description      = "Allow all ingress traffic on standard HTTP port"
    },
    {
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      self             = false
      prefix_list_ids  = []
      security_groups  = []
      description      = "Allow all ingress traffic on standard HTTPS port"
    }
  ]

  tags = {
    Name = "${var.app_name}-security-alb"
  }
}
