resource "aws_s3_bucket" "amzn-bucket" {
  bucket = "amzn-tf-s3-bucket"

  tags = {
    Name        = "My Terraform bucket"
    Environment = "Dev"
  }
}
