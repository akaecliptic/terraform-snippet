// iam role associated to use with app ec2 instances
resource "aws_iam_role" "app_role" {
  name = "${var.app_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

// associates role with instance profile, allowing application to access aws resources
resource "aws_iam_instance_profile" "app_instance_profile" {
  name = "${var.app_name}-instance-profile"
  role = aws_iam_role.app_role.name
}

// policy enables access to ecr, s3, and secrets manager
resource "aws_iam_role_policy" "app_role_policy" {
  name = "${var.app_name}-role-policy"
  role = aws_iam_role.app_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Action" : "s3:*",
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ],
        "Resource" : "arn:aws:secretsmanager:*:*:secret:*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ecr:GetAuthorizationToken",
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchImportUpstreamImage"
        ],
        "Resource" : "*"
      }
    ]
  })
}
