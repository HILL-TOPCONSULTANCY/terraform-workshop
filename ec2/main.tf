resource "aws_instance" "devops" {
  ami             = var.ami
  instance_type   = var.instance_type
  subnet_id       = var.subnet_id

  user_data = file("${path.module}/../user_data.sh")

  tags = {
    Name        = "devops-ec2"
    Environment = "PROD"
  }
}

output "instance_id" {
  value = aws_instance.devops.id
}
