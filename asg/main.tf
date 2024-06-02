resource "aws_launch_configuration" "devops" {
  name          = "devops-launch-configuration"
  image_id      = "ami-0d191299f2822b1fa"
  instance_type = var.instance_type

  user_data = file("${path.module}/../user_data.sh")

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name        = "devops-launch-configuration"
    Environment = "PROD"
  }
}

resource "aws_autoscaling_group" "devops" {
  desired_capacity     = 3
  max_size             = 3
  min_size             = 1
  vpc_zone_identifier  = var.subnets

  launch_configuration = aws_launch_configuration.devops.id

  tags = [
    {
      key                 = "Name"
      value               = "devops-asg"
      propagate_at_launch = true
    },
    {
      key                 = "Environment"
      value               = "PROD"
      propagate_at_launch = true
    }
  ]
}
