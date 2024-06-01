Sure, I'll add the server type (Amazon Linux 2) to the Terraform configuration for the EC2 instance. Below is the updated README.md file with the Terraform configurations that specify Amazon Linux 2 as the AMI.

### README.md

# AWS Terraform Jenkins CI/CD Pipeline

This repository contains Terraform configurations to create an AWS EC2 instance and an S3 bucket. The deployment is automated using Jenkins, with manual approval steps integrated into the pipeline.

## Prerequisites

Before you begin, ensure you have the following prerequisites:

- **AWS Account**: An AWS account with sufficient permissions to create EC2 instances and S3 buckets.
- **Jenkins Server**: Jenkins installed and running on a server.
- **Git**: Git installed on your local machine or server.
- **Terraform**: Terraform installed on your local machine or Jenkins server.
- **SSH Key Pair**: An SSH key pair to access the EC2 instance.

## Installation Steps

### 1. Install Git

Update the package index and install Git:

```sh
sudo apt-get update
sudo apt-get install git -y
```

Verify Git installation:

```sh
git --version
```

### 2. Install Java

Jenkins requires Java to run. Install Java with the following commands:

```sh
sudo apt-get update
sudo apt-get install openjdk-11-jdk -y
```

### 3. Add Jenkins Repository Key

Add the Jenkins repository key:

```sh
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
```

### 4. Add Jenkins Repository

Add the Jenkins repository to the sources list:

```sh
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update
```

### 5. Install Jenkins

Install Jenkins with the following command:

```sh
sudo apt-get install jenkins -y
```

### 6. Start Jenkins

Start and enable the Jenkins service:

```sh
sudo systemctl start jenkins
sudo systemctl enable jenkins
```

### 7. Access Jenkins

Open your browser and go to `http://YOUR_SERVER_IP:8080`.

Retrieve the initial admin password:

```sh
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

### 8. Install Terraform

Download Terraform from the official website and install it. Alternatively, you can use the package manager for your operating system.

For Ubuntu:

```sh
sudo apt-get update
sudo apt-get install -y gnupg software-properties-common curl
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update
sudo apt-get install terraform
```

Verify Terraform installation:

```sh
terraform --version
```

## Jenkins Configuration

### 1. Configure Jenkins Credentials

- Go to Jenkins dashboard.
- Navigate to `Manage Jenkins` > `Manage Credentials` > `(global)` > `Add Credentials`.
- Add your AWS Access Key ID and Secret Access Key as separate credentials.

### 2. Create a New Jenkins Pipeline

- Go to Jenkins dashboard.
- Click on `New Item`, enter a name for your pipeline, select `Pipeline`, and click `OK`.
- In the pipeline configuration, under the `Pipeline` section, choose `Pipeline script from SCM`.
- Select `Git` and provide the repository URL: `https://github.com/YOUR_GITHUB_USERNAME/aws-terraform-jenkins.git`.
- Specify the branch name (`main` or your branch name).


## Terraform Configuration

### EC2 Configuration

1. **Create the `main.tf` File for EC2**

   ```sh
   mkdir ec2
   nano ec2/main.tf
   ```

   Add the following configuration:

   ```hcl
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
   ```

2. **Create the `variables.tf` File for EC2**

   ```sh
   nano ec2/variables.tf
   ```

   Add the following configuration:

   ```hcl
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
     default     = "ami-0c55b159cbfafe1f0" // Amazon Linux 2 AMI ID for us-east-1
     type        = string
   }
   ```

3. **Create the `terraform.tfvars` File for EC2**

   ```sh
   nano ec2/terraform.tfvars
   ```

   Add the following configuration:

   ```hcl
   region = "us-east-1"
   instance_type = "t2.medium"
   ami = "ami-0c55b159cbfafe1f0"  // Amazon Linux 2 AMI ID for us-east-1
   ```

###

 S3 Configuration

1. **Create the `main.tf` File for S3**

   ```sh
   mkdir s3
   nano s3/main.tf
   ```

   Add the following configuration:

   ```hcl
   provider "aws" {
     region = var.region
   }

   resource "aws_s3_bucket" "example" {
     bucket = var.bucket_name

     tags = {
       Name = "TerraformExampleBucket"
     }
   }

   output "bucket_arn" {
     value = aws_s3_bucket.example.arn
   }
   ```

2. **Create the `variables.tf` File for S3**

   ```sh
   nano s3/variables.tf
   ```

   Add the following configuration:

   ```hcl
   variable "region" {
     description = "AWS region"
     default     = "us-east-1"
     type        = string
   }

   variable "bucket_name" {
     description = "S3 bucket name"
     type        = string
   }
   ```

3. **Create the `terraform.tfvars` File for S3**

   ```sh
   nano s3/terraform.tfvars
   ```

   Add the following configuration:

   ```hcl
   region = "us-east-1"
   bucket_name = "my-unique-bucket-name-12345"  // Ensure this bucket name is unique
   ```

### Summary

This guide helps you set up a Jenkins pipeline to automate the creation of an AWS EC2 instance and an S3 bucket using Terraform. The Jenkins pipeline includes manual approval steps for better control and security. Follow the installation and configuration steps to get your CI/CD pipeline up and running. The Terraform configurations specify Amazon Linux 2 as the AMI for the EC2 instance.
