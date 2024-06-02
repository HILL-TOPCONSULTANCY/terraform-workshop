provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.10.0"

  name = "devops-vpc"
  cidr = var.vpc_cidr

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  public_subnets  = var.public_subnets

  tags = {
    Name        = "devops-vpc"
    Environment = "PROD"
  }
}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "6.4.0"

  name    = "devops-alb"
  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.public_subnets

  tags = {
    Name        = "devops-alb"
    Environment = "PROD"
  }
}

module "asg" {
  source = "./asg"

  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.public_subnets

  tags = {
    Name        = "devops-asg"
    Environment = "PROD"
  }
}

module "ec2" {
  source    = "./ec2"

  vpc_id    = module.vpc.vpc_id
  subnet_id = module.vpc.public_subnets[0]

  tags = {
    Name        = "devops-ec2"
    Environment = "PROD"
  }
}
