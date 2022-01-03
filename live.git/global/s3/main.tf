provider "aws" {
  region = "var.aws_region"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-okta-backend-pputman"

  # Prevent accidental deletion of this S3 bucket
  lifecycle {
    prevent_destroy = true
  }

  # Enable versioning so we can see the full revision history of our
  # state files
  versioning {
    enabled = true
  }

  # Enable server-side encryption by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  logging {
    target_bucket = aws_s3_bucket.log_bucket.id
    target_prefix = "log/"
  }


}

resource "aws_s3_bucket_public_access_block" "access_block_tf_state" {
  bucket                  = aws_s3_bucket.terraform_state.id
  restrict_public_buckets = true
  ignore_public_acls      = true
  block_public_acls       = true
  block_public_policy     = true
}

resource "aws_s3_bucket" "log_bucket" {
  bucket = "okta-pputman-tf-log-bucket"
  acl    = "log-delivery-write"
  versioning {
    enabled = true
  }

  # Enable server-side encryption by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

}

resource "aws_s3_bucket_public_access_block" "access_ctl_log_bucket" {
  bucket                  = aws_s3_bucket.log_bucket.id
  restrict_public_buckets = true
  ignore_public_acls      = true
  block_public_acls       = true
  block_public_policy     = true
}

