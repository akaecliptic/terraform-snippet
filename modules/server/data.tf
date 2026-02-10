// using default vpc throughout app
data "aws_vpc" "app_vpc" {
  default = true
}

// using default subnets too
data "aws_subnets" "app_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.app_vpc.id]
  }
}

// key pair used for connecting to ec2 instances,
// ssh is typically disabled, but good to have
data "aws_key_pair" "app_key" {
  key_name           = var.app_key_name
  include_public_key = true
}

// certificate associated with app domain
data "aws_acm_certificate" "app_certificate" {
  domain   = var.app_domain
  statuses = ["ISSUED"]
}
