terraform {
  backend "s3" {
    key = "staging/accounts/okta-groups/terraform.tfstate"
  }
}



module "okta-groups" {
  source       = "../../../modules/accounts/okta-groups/"
  cluster_name = "okta-groups-staging"

  vault_address  = "http://127.0.0.1:8200"
  vault_path     = "secret/okta_creds"
  okta_org_name  = "teramindpputman"
  okta_base_url  = "okta.com"
  okta_api_token = module.okta-groups.okta_creds.data["api_token"]

  apps = {
    "Salesforce"            = { rule = "user.department == \"Sales\" OR user.department == \"Marketing\"" },
    "aws-384338-FullAccess" = { rule = "user.email == \"putman.patrick@gmail.com\"" },
    "aws-test-FullAccess"   = { rule = "user.email == \"putman.patrick@gmail.com\"" },
    "aws-975678609170-AdministratorAccess" = { rule = join(" ", [
      #      "user.email == \"putman.patrick@gmail.com\" OR",   # Admin
      "user.email == \"sally@example.com\"" # CTO
      ])
    },
    "aws-975678609170-test_policy2" = { rule = "user.email == \"putman.patrick@gmail.com\"" },
  }
}
