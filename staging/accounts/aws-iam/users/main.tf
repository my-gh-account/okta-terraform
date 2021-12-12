terraform {
  backend "s3" {
    key            = "staging/accounts/aws-iam/users/terraform.tfstate"
  }
}


provider "aws" {
	region = "us-east-2"
}



