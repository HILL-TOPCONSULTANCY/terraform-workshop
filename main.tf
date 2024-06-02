provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "./vpc"
}

module "alb" {
  source = "./alb"
  vpc_id = module.vpc.vpc_id
  subnets = module.vpc.public_subnets
}

module "asg" {
  source = "./asg"
  vpc_id = module.vpc.vpc_id
  subnets = module.vpc.public_subnets
}

module "ec2" {
  source = "./ec2"
  vpc_id = module.vpc.vpc_id
  subnet_id = module.vpc.public_subnets[0]
}
