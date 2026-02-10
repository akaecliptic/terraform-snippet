/// s3
//
// defining s3 bucket to store loadbalancer access logs
//

// s3 for alb access logs
resource "aws_s3_bucket" "logs_storage" {
  bucket = "${var.app_name}-logs"
}

// bucket needs encryption so it can be used with alb
resource "aws_s3_bucket_server_side_encryption_configuration" "logs_storage_encryption" {
  bucket = aws_s3_bucket.logs_storage.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

// defining alb access permission for logs bucket
data "aws_iam_policy_document" "logs_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["logdelivery.elasticloadbalancing.amazonaws.com"]
    }

    actions = [
      "s3:PutObject"
    ]

    resources = [
      "${aws_s3_bucket.logs_storage.arn}/*"
    ]
  }
}

// attaching policy to logs bucket
resource "aws_s3_bucket_policy" "logs_storage_policy" {
  bucket = aws_s3_bucket.logs_storage.id
  policy = data.aws_iam_policy_document.logs_policy.json
}

/// loadbalancer
//
// defining an application loadbalancer to manage and route incoming traffic
//

// alb for app instances
resource "aws_lb" "app_alb" {
  name               = "${var.app_name}-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [aws_security_group.app_security_alb.id]
  subnets         = toset(data.aws_subnets.app_subnets.ids)

  enable_deletion_protection = true

  access_logs {
    bucket  = aws_s3_bucket.logs_storage.id
    prefix  = "${var.app_name}-alb"
    enabled = true
  }
}

// allow https traffic on standard port 443
resource "aws_lb_listener" "app_alb_listener_forward_https" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = data.aws_acm_certificate.app_certificate.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_target_group.arn
  }
}

// redirect http traffic on standard port 80, to https on 443
resource "aws_lb_listener" "app_alb_listener_redirect_http" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

/// autoscaling group
//
// defining an autoscaling group and target group to manage horizontally scaling app instances
//

// asg to handle horizontal scaling and instance refreshing 
resource "aws_autoscaling_group" "app_asg" {
  name                = "${var.app_name}-asg"
  desired_capacity    = 1
  max_size            = 1
  min_size            = 1
  vpc_zone_identifier = toset(data.aws_subnets.app_subnets.ids)

  launch_template {
    id      = aws_launch_template.app_launch_template.id
    version = "$Latest"
  }
}

// target group directing asg traffic to ec2 instances
resource "aws_lb_target_group" "app_target_group" {
  name     = "${var.app_name}-instances"
  port     = var.app_ingress_port
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.app_vpc.id

  health_check {
    port     = var.app_ingress_port
    path     = "/healthcheck"
    timeout  = 3
    protocol = "HTTP"
  }
}

// associating target group with autoscaling group
resource "aws_autoscaling_attachment" "app_asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.app_asg.id
  lb_target_group_arn    = aws_lb_target_group.app_target_group.arn
}
