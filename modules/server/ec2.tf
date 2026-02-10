// using latest amazon linux 2023 with x86_64 architecture
data "aws_ami" "app_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "name"
    values = ["al2023-ami-2023*"]
  }
}

// basic template built on amazon linux with user data file for application configuration
resource "aws_launch_template" "app_launch_template" {
  name = "${var.app_name}-launch-template"

  instance_type = var.app_instane_type
  image_id      = data.aws_ami.app_ami.image_id

  key_name               = data.aws_key_pair.app_key.key_name
  vpc_security_group_ids = [aws_security_group.app_security_ec2.id]

  user_data = filebase64(var.app_user_data_path)

  metadata_options {
    // the application runs on containers within the ec2 instances,
    // this ensures iam roles are correctly during aws related operations
    http_put_response_hop_limit = 2
    instance_metadata_tags      = "enabled"
  }

  iam_instance_profile {
    arn = aws_iam_instance_profile.app_instance_profile.arn
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.app_name}-app"
    }
  }
}
