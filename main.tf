provider "aws" {
  region = var.region
}

resource "aws_instance" "example" {
  ami           = var.ami
  instance_type = var.instance_type

  tags = {
    Name = "TerraformExample"
  }
}

output "instance_ip" {
  value = aws_instance.example.public_ip
}
