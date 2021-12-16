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
    } 
}



