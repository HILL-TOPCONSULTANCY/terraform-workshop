provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "devops_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name        = "devops"
    Environment = "hill-top"
  }
}

resource "aws_subnet" "devops_subnet" {
  vpc_id            = aws_vpc.devops_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name        = "devops"
    Environment = "hill-top"
  }
}

resource "aws_internet_gateway" "devops_igw" {
  vpc_id = aws_vpc.devops_vpc.id
  tags = {
    Name        = "devops"
    Environment = "hill-top"
  }
}

resource "aws_route_table" "devops_route_table" {
  vpc_id = aws_vpc.devops_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.devops_igw.id
  }
  tags = {
    Name        = "devops"
    Environment = "hill-top"
  }
}

resource "aws_route_table_association" "devops_route_table_association" {
  subnet_id      = aws_subnet.devops_subnet.id
  route_table_id = aws_route_table.devops_route_table.id
}

resource "aws_security_group" "allow_ssh_http" {
  vpc_id      = aws_vpc.devops_vpc.id
  description = "Allow SSH and HTTP"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "devops"
    Environment = "hill-top"
  }
}

resource "aws_instance" "devops" {
  count                   = 2
  ami                     = "ami-0d191299f2822b1fa"
  instance_type           = "t2.micro"
  subnet_id               = aws_subnet.devops_subnet.id
  vpc_security_group_ids  = [aws_security_group.allow_ssh_http.id]
  associate_public_ip_address = true
  user_data = file("${path.module}/user_data.sh")

  tags = {
    Name        = "devops-${count.index + 1}"
    Environment = "hill-top"
  }

  lifecycle {
    create_before_destroy = true
  }
}

output "vpc_id" {
  value = aws_vpc.devops_vpc.id
}

output "instance_ids" {
  value = aws_instance.devops.*.id
}

output "public_ips" {
  value = aws_instance.devops.*.public_ip
}

output "subnet_id" {
  value = aws_subnet.devops_subnet.id
}
