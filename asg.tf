resource "aws_launch_configuration" "devops" {
  image_id        = var.ami
  instance_type   = var.instance_type
  security_groups = [aws_security_group.ec2_sg.id]

  user_data = file("${path.module}/user_data.sh")

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name        = "devops-lc"
    Environment = "PROD"
  }
}

resource "aws_autoscaling_group" "devops" {
  launch_configuration = aws_launch_configuration.devops.id
  min_size             = 1
  max_size             = 3
  desired_capacity     = 3
  vpc_zone_identifier  = module.vpc.public_subnets

  target_group_arns = [module.alb.this_lb_target_group_arn]

  tag {
    key                 = "Name"
    value               = "devops-asg"
    propagate_at_launch = true
  }

  health_check_type         = "EC2"
  health_check_grace_period = 300

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name        = "devops-asg"
    Environment = "PROD"
  }
}
