
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
sudo yum update -y
sudo yum install git -y
```

Verify Git installation:

```sh
git --version
```

### 2. Install Java

Jenkins requires Java to run. Install Java with the following commands:

```sh
sudo yum update -y
sudo yum install java-11-amazon-corretto -y
```

### 3. Add Jenkins Repository 

Add the Jenkins repository :

```sh
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
```

### 4. Install Jenkins

Install Jenkins with the following command:

```sh
sudo yum install jenkins -y
```

### 5. Start Jenkins

Start and enable the Jenkins service:

```sh
sudo systemctl start jenkins
sudo systemctl enable jenkins
```

### 6. Access Jenkins

Open your browser and go to `http://YOUR_SERVER_IP:8080`.

Retrieve the initial admin password:

```sh
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

### 8. Install Terraform

Download Terraform from the official website and install it. Alternatively, you can use the package manager for your operating system.

For Ubuntu:

```sh
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform
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
