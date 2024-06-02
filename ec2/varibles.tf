variable "ami" {
  default = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI
}
variable "instance_type" {
  default = "t2.micro"
}
variable "subnet_id" {}
variable "vpc_id" {}
