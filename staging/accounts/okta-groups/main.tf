terraform {
  backend "s3" {
    key = "staging/accounts/okta-groups/terraform.tfstate"
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


module "okta-groups" {
  source        = "../../../modules/accounts/okta-groups/"
  cluster_name  = "okta-groups-staging"
  
  apps = {
    "Salesforce"            = { rule = "user.department == \"Sales\" OR user.department == \"Marketing\""},
    "aws-384338-FullAccess" = { rule = "user.email == \"putman.patrick@gmail.com\""},
    "aws-test-FullAccess"   = { rule = "user.email == \"putman.patrick@gmail.com\""},
    "aws-975678609170-AdministratorAccess" = { rule = join(" ", [
#      "user.email == \"putman.patrick@gmail.com\" OR",   # Admin
      "user.email == \"sally@example.com\""             # CTO
      ])
      },
    "aws-975678609170-test_policy2" = { rule = "user.email == \"putman.patrick@gmail.com\""},
    }
}
