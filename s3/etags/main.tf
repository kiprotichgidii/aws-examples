terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
}

resource "aws_s3_bucket" "amzn-bucket" {
  bucket = "amzn-tf-s3-bucket"

  tags = {
    Name        = "My Terraform bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.amzn-bucket.bucket
  key    = "index.html"
  source = "index.html"

  etag = filemd5("index.html")
}
