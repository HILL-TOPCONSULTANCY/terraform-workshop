module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "6.4.0"

  name    = "devops-alb"
  vpc_id  = var.vpc_id
  subnets = var.subnets

  tags = {
    Name        = "devops-alb"
    Environment = "PROD"
  }
}

resource "aws_lb_target_group" "devops-tg" {
  name     = "devops-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }

  tags = {
    Name        = "devops-tg"
    Environment = "PROD"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = module.alb.this_lb_arn
  port              = 80
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.devops-tg.arn
  }
}

resource "aws_lb_listener_rule" "devops-rule" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.devops-tg.arn
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}
