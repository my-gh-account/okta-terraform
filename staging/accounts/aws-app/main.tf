terraform {
  backend "s3" {
    key = "staging/accounts/aws-app/terraform.tfstate"
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

module "aws-app" {
  source        = "../../../modules/accounts/aws-app/"
  cluster_name  = "aws-app-staging"
  app_filter	= "okta"
  saml_provider = "Okta-SSO"
}
