variable "ami" {
  description = "AMI ID for the instance"
  type        = string
  default     = "ami-0d191299f2822b1fa" # Amazon Linux 2 AMI
}

variable "instance_type" {
  description = "Instance type"
  type        = string
  default     = "t2.micro"
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}
