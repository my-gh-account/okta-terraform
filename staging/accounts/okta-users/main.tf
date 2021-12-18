terraform {
  backend "s3" {
    key = "staging/accounts/okta-users/terraform.tfstate"
  }
}

module "okta-users" {
  source         = "../../../modules/accounts/okta-users/"
  cluster_name   = "okta-users-staging"
  vault_address  = "http://127.0.0.1:8200"
  vault_path     = "secret/okta_creds"
  okta_org_name  = "teramindpputman"
  okta_base_url  = "okta.com"
  okta_api_token = module.okta-users.okta_creds.data["api_token"]
  okta-users = [{
    first_name = "Patrick"
    last_name  = "Putman"
    login      = "putman.patrick@gmail.com"
    email      = "putman.patrick@gmail.com"
    },
    {
      first_name = "Bob"
      last_name  = "Johnson"
      login      = "bob@example.com"
      email      = "bob@example.com"
    },
    {
      first_name = "Sally"
      last_name  = "Parker"
      login      = "sally@example.com"
      email      = "sally@example.com"
    },
  ]
}

