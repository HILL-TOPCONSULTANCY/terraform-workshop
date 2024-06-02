variable "vpc_id" {}
variable "subnets" {
  type = list(string)
}
variable "instance_type" {
  default = "t2.micro"
}
