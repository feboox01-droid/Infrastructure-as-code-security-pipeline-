provider "aws" {
  region = "us-east-1"
}

# 1. THE ARCHITECTED SECURE BUCKET
resource "aws_s3_bucket" "my_secure_bucket" {
  bucket = "my-final-secure-bucket-001122"

  # Ye comments Checkov ko bolti hain ki in checks ko ignore karo
  # Hum ye isliye kar rahe hain kyunki ye ek demo project hai
  # checkov:skip=CKV_AWS_18: "Logging not required for this demo"
  # checkov:skip=CKV_AWS_144: "Cross-region replication not needed"
  # checkov:skip=CKV_AWS_145: "Lifecycle non-current version not needed"
  # checkov:skip=CKV2_AWS_61: "Lifecycle configuration not required"
  # checkov:skip=CKV2_AWS_62: "Event notifications not required"
}

# Fix for CKV_AWS_21 (Versioning)
resource "aws_s3_bucket_versioning" "v_eng" {
  bucket = aws_s3_bucket.my_secure_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Fix for CKV_AWS_23, 21 (Public Access Block)
resource "aws_s3_bucket_public_access_block" "public_block" {
  bucket = aws_s3_bucket.my_secure_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Fix for CKV2_AWS_5 (HTTPS/Secure Transport only)
resource "aws_s3_bucket_policy" "allow_access" {
  bucket = aws_s3_bucket.my_secure_bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowSSLRequestsOnly"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource = [
          aws_s3_bucket.my_secure_bucket.arn,
          "${aws_s3_bucket.my_secure_bucket.arn}/*"
        ]
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
      }
    ]
  })
}

# 2. SECURE SECURITY GROUP
resource "aws_security_group" "allow_ssh_secure" {
  name        = "allow_ssh_secure"
  description = "Allow SSH inbound traffic"

  ingress {
    description = "SSH from specific IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.1/32"] 
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}