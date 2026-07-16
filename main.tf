# AWS Provider
provider "aws" {
  region = "us-east-1"
}

# 1. SECURE S3 Bucket (Public Access Blocked)
resource "aws_s3_bucket" "my_secure_bucket" {
  bucket = "my-very-secret-data-12345-secured" # Bucket name must be unique
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.my_secure_bucket.id

  # Ab hum sab kuch TRUE kar rahe hain (Public access block!)
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# 2. SECURE Security Group (Restricted SSH)
resource "aws_security_group" "allow_ssh_secure" {
  name        = "allow_ssh_secure"
  description = "Allow SSH inbound traffic from specific IP only"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    # 0.0.0.0/0 hata kar humne ek dummy specific IP daal diya
    cidr_blocks = ["10.0.0.1/32"] 
  }
}