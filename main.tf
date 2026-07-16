provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "my_secure_bucket" {
  bucket = "cloud-sec-project-bucket-${random_id.id.hex}"
}

resource "random_id" "id" {
  byte_length = 4
}

resource "aws_s3_bucket_public_access_block" "public_block" {
  bucket = aws_s3_bucket.my_secure_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_security_group" "allow_ssh_secure" {
  name        = "allow_ssh_secure"
  description = "Allow SSH inbound traffic"

  ingress {
    description = "SSH from private IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.1/32"] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}