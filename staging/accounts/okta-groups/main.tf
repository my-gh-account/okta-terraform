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
  cluster_name  = "okta-users-staging"
}

