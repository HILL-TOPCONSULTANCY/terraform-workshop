terraform {
  backend "s3" {
    bucket         = "terraform-state-bucket-devops-hilltop"
    key            = "terraform/state"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
