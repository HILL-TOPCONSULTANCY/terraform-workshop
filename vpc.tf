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
