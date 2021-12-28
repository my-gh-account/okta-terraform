#-------------------------------------------------------------------------------------------------------------------------------------
# OKTA S3 BACKEND
# There's a number of reasons to use a backend instead of a local state, this is to use the specified key in s3 backend
#-------------------------------------------------------------------------------------------------------------------------------------

terraform {
  backend "s3" {
    key = "staging/accounts/google-workspaces/terraform.tfstate"
  }
}


#-------------------------------------------------------------------------------------------------------------------------------------
# OKTA PROVIDER VERSION REQUIREMENTS 
# Okta's resource requires you specify this version to work
#-------------------------------------------------------------------------------------------------------------------------------------

terraform {
  required_providers {
    okta = {
      source = "okta/okta"
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
  path = var.vault_okta_secret_path
}




#-------------------------------------------------------------------------------------------------------------------------------------
# OKTA CREDENTIALS
# allows login to okta, api_token pointing here to data source created for hashicorp vault secure secret storage
#-------------------------------------------------------------------------------------------------------------------------------------

provider "okta" {
  org_name  = var.okta_org_name
  base_url  = var.okta_account_url
  api_token = data.vault_generic_secret.okta_creds.data["api_token"]
}


#-------------------------------------------------------------------------------------------------------------------------------------
# MODULE REFERENCE
# sets variables defined in module and can set in variables.tf, see module at source for explanation 
#-------------------------------------------------------------------------------------------------------------------------------------

module "google-workspaces" {
  source            = "../../../modules/accounts/google-workspaces/"
  app_name          = var.app_name
  app_display_name  = var.app_display_name
  accounts          = var.accounts
  app_settings_json = var.app_settings_json
}
