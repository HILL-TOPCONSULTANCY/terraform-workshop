provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "./vpc"
}

module "alb" {
  source = "./alb"
}

module "asg" {
  source = "./asg"
}

module "ec2" {
  source = "./ec2"
}
