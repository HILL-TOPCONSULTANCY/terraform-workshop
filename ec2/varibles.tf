variable "ami" {
  default = "ami-0d191299f2822b1fa" # Amazon Linux 2 AMI
}
variable "instance_type" {
  default = "t2.micro"
}
variable "subnet_id" {}
variable "vpc_id" {}
