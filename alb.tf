module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "6.4.0"

  name               = "devops-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = module.vpc.public_subnets

  enable_deletion_protection = false

  tags = {
    Name        = "devops-alb"
    Environment = "PROD"
  }
}
