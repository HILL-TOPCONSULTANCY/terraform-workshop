provider "aws" {
  region = var.region
}

resource "aws_instance" "jenkins-server" {
  ami           = var.ami
  instance_type = var.instance_type

  tags = {
    Name = "jenkins-server"
  }
}

output "instance_ip" {
  value = aws_instance.jenkins-server.public_ip
}
