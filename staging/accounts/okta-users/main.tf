terraform {
  backend "s3" {
    key = "staging/accounts/okta-users/terraform.tfstate"
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

module "okta-users" {
  source = "../../../modules/accounts/okta-users/"
  cluster_name = "okta-users-staging"
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

