resource "aws_launch_configuration" "devops" {
  name          = "devops-launch-configuration"
  image_id      = "ami-0c55b159cbfafe1f0"
  instance_type = var.instance_type

  user_data = file("${path.module}/../user_data.sh")

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "devops" {
  desired_capacity     = 3
  max_size             = 3
  min_size             = 1
  vpc_zone_identifier  = var.subnets

  launch_configuration = aws_launch_configuration.devops.id

  tag {
    key                 = "Name"
    value               = "devops-asg"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = "PROD"
    propagate_at_launch = true
  }
}

output "asg_id" {
  value = aws_autoscaling_group.devops.id
}
