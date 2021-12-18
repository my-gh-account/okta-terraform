terraform {
  backend "s3" {
    key = "staging/accounts/aws-app/terraform.tfstate"
  }
}

provider "aws" {
  region = "us-east-2"
}

module "aws-app" {
  source       = "../../../modules/accounts/aws-app/"
  cluster_name = "aws-app-staging"

  vault_address = "http://127.0.0.1:8200"
  vault_path    = "secret/okta_creds"

  okta_org_name  = "teramindpputman"
  okta_base_url  = "okta.com"
  okta_api_token = module.aws-app.okta_creds.data["api_token"]

  app_filter    = "okta"
  saml_provider = "Okta-SSO"
}
