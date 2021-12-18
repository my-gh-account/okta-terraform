#-------------------------------------------------------------------------------------------------------------------------------------
# OKTA S3 BACKEND
# There's a number of reasons to use a backend instead of a local state, this is to use the specified key in s3 backend
#-------------------------------------------------------------------------------------------------------------------------------------


terraform {
  backend "s3" {
    key = "staging/accounts/okta-users/terraform.tfstate"
  }
}



#-------------------------------------------------------------------------------------------------------------------------------------
# OKTA PROVIDER VERSION REQUIREMENTS 
# Okta's resource requires you specify this version to work
#-------------------------------------------------------------------------------------------------------------------------------------

terraform {
  required_providers {
    okta = {
      source  = "okta/okta"
      version = "~> 3.20"
    }
  }
}


#-------------------------------------------------------------------------------------------------------------------------------------
# HASHICORP VAULT TO SAFELY STORE OKTA CREDENTIALS 
# This allows us to safely store okta API Token  without them appearing in tfstate file
#-------------------------------------------------------------------------------------------------------------------------------------


provider "vault" {
  address = var.vault_address
}

data "vault_generic_secret" "okta_creds" {
  path = var.vault_secret_path
}

provider "okta" {
  org_name  = "teramindpputman"
  base_url  = "okta.com"
  api_token = data.vault_generic_secret.okta_creds.data["api_token"]
}



#-------------------------------------------------------------------------------------------------------------------------------------
# OKTA USER MODULE REFERENCE WITH DEFINED USERS 
# Define users below in same format.
#-------------------------------------------------------------------------------------------------------------------------------------


module "okta-users" {
  source       = "../../../modules/accounts/okta-users/"
  okta_users = [{
      first_name = "Patrick"
      last_name  = "Putman"
      login      = "putman.patrick@gmail.com"
      email      = "putman.patrick@gmail.com"
    },
#    {
#      first_name = "Bob"
#      last_name  = "Johnson"
#      login      = "bob@example.com"
#      email      = "bob@example.com"
#    },
    {
      first_name = "Sally"
      last_name  = "Parker"
      login      = "sally@example.com"
      email      = "sally@example.com"
    },
  ]

}

