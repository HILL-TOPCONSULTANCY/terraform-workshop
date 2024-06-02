provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.10.0"

  name = "devops-vpc"
  cidr = var.vpc_cidr

  azs             = slice(data.aws_availability_zones.available.names, 0, 3)
  public_subnets  = var.public_subnets

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "devops-vpc"
    Environment = "PROD"
  }
}

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

module "ec2" {
  source = "./ec2"

  vpc_id          = module.vpc.vpc_id
  public_subnets  = module.vpc.public_subnets
  instance_type   = var.instance_type
  ami             = var.ami
  security_groups = [aws_security_group.ec2_sg.id]
  user_data       = data.template_file.user_data.rendered
}

module "asg" {
  source = "./asg"

  vpc_id                  = module.vpc.vpc_id
  public_subnets          = module.vpc.public_subnets
  instance_type           = var.instance_type
  ami                     = var.ami
  alb_target_group_arn    = module.alb.target_group_arn
  security_groups         = [aws_security_group.ec2_sg.id]
  user_data               = data.template_file.user_data.rendered
}

resource "aws_security_group" "alb_sg" {
  name        = "devops-alb-sg"
  description = "Security group for ALB"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "devops-alb-sg"
    Environment = "PROD"
  }
}

resource "aws_security_group" "ec2_sg" {
  name        = "devops-ec2-sg"
  description = "Security group for EC2 instances"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "devops-ec2-sg"
    Environment = "PROD"
  }
}

data "aws_availability_zones" "available" {}

data "template_file" "user_data" {
  template = file("${path.module}/user_data.sh")
}
