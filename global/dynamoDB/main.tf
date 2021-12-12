terraform {
  backend "s3" {
    key            = "global/DynamoDB/terraform.tfstate"
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-okta-backend-pputman"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}


