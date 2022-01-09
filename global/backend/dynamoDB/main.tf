provider "aws" {
  region = var.aws_region
}


resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-okta-backend-pputman"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  server_side_encryption {
    enabled = true
  }

  attribute {
    name = "LockID"
    type = "S"
  }
}


