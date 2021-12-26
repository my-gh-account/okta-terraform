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
    }
  }
}

#-------------------------------------------------------------------------------------------------------------------------------------
# VAULT VARIABLES 
# Refers to variables for Hashicorp Vault in variables.tf
#-------------------------------------------------------------------------------------------------------------------------------------

provider "vault" {
  address = var.vault_address
}

data "vault_generic_secret" "okta_creds" {
  path = var.vault_secret_path
}


#-------------------------------------------------------------------------------------------------------------------------------------
# OKTA CREDENTIALS
# allows login to okta, api_token pointing here to data source created for hashicorp vault secure secret storage
#-------------------------------------------------------------------------------------------------------------------------------------

provider "okta" {
  org_name  = var.okta_org_name 
  base_url  = var.okta_account_url
  api_token = data.vault_generic_secret.okta_creds.data[var.api_token]
}



#-------------------------------------------------------------------------------------------------------------------------------------
# OKTA USER MODULE REFERENCE WITH DEFINED USERS 
# Define users below in same format.
#-------------------------------------------------------------------------------------------------------------------------------------

module "okta-users" {
  source = "../../../modules/accounts/okta-users/"
  okta_users = [
    {
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
    {
      first_name = "Test"
      last_name  = "User"
      login      = "testuser@example.com"
      email      = "testuser@example.com"
    },
    {
      first_name = "Test"
      last_name  = "User"
      login      = "test@deserthomescleaning.com"
      email      = "test@deserthomescleaning.com"
    },

  ]
}

