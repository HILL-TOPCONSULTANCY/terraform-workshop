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
  vpc_id     = aws_vpc.devops_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name        = "devops"
    Environment = "hill-top"
  }
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

  tags = {
    Name        = "devops-${count.index + 1}"
    Environment = "hill-top"
  }

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              HOST_IP=$(hostname -f)
              CURRENT_DATE=$(date '+%Y-%m-%d %H:%M:%S')
              cat > /var/www/html/index.html <<EOL
              <!DOCTYPE html>
              <html lang="en">
              <head>
                  <meta charset="UTF-8">
                  <meta name="viewport" content="width=device-width, initial-scale=1.0">
                  <title>Welcome to Hill-Top Consultancy DevOps CLASS 2024A</title>
                  <style>
                      body { background-color: #f0f0f0; text-align: center; font-family: Arial, sans-serif; font-size: 24px; }
                      h1, h2, p { margin: 24px 0; }
                      h1 { color: #007bff; font-weight: bold; font-size: 32px; }
                      h2 { color: #007bff; font-weight: bold; font-size: 24px; }
                      .content { background-color: #ffffff; margin: auto; padding: 20px; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); width: 80%; max-width: 600px; }
                  </style>
              </head>
              <body>
                  <div class="content">
                      <h1>Welcome to Hill-Top Consultancy DevOps CLASS 2024A</h2>
                      <h2>This is the Current Host IP Address: $HOST_IP</h2>
                      <p>Current Date and Time: $CURRENT_DATE</p>
                      <p>Hill-Top Consultancy is a premier IT training and consulting firm that was founded with the vision of empowering professionals and organizations by providing them with cutting-edge skills in DevOps, Cloud Computing, and Software Development. Our ethos is built on the foundation of continuous learning and innovation, which we believe are essential in navigating the ever-evolving technology landscape.</p>
                      <p><strong>Email:</strong> info@htconsultancy.net</p>
                      <p><strong>Phone:</strong> +45 715 740 47</p>
                      <p><strong>Address:</strong> 2630 Taastrup, Denmark</p>
                  </div>
              </body>
              </html>
              EOF

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
