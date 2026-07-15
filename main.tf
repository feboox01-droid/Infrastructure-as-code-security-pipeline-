# AWS Provider Setup
provider "aws" {
  region = "us-east-1"
}

# 1. Insecure S3 Bucket (Publicly Accessible - Dangerous!)
resource "aws_s3_bucket" "my_insecure_bucket" {
  bucket = "my-very-secret-data-12345"
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.my_insecure_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# 2. Insecure Security Group (SSH open to the whole world - 0.0.0.0/0)
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Sabke liye khula hai!
  }
}