resource "aws_instance" "devops" {
  count         = 3
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = element(module.vpc.public_subnets, count.index)
  security_groups = [aws_security_group.ec2_sg.id]

  user_data = file("${path.module}/user_data.sh")

  tags = {
    Name        = "devops-instance-${count.index}"
    Environment = "PROD"
  }
}
