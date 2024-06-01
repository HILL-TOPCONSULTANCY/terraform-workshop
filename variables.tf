variable "region" {
  description = "AWS region"
  default     = "us-east-1"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.medium"
  type        = string
}

variable "ami" {
  description = "AMI ID"
  default     = "ami-0d191299f2822b1fa"
  type        = string
}
