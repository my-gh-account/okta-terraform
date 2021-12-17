terraform {
  backend "s3" {
    key            = "staging/accounts/aws-roles/terraform.tfstate"
  }
}

terraform {
  required_providers {
    okta = {
      source  = "okta/okta"
      version = "~> 3.20"
    }
  }
}


provider "aws" {
	region = "us-east-2"
}

module "aws-roles" {
  source        = "../../../modules/accounts/aws-roles/"
  cluster_name  = "okta-aws-roles-staging"
   
}
