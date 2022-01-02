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
# GOOGLE CREDENTIALS
# Google api token file
#-------------------------------------------------------------------------------------------------------------------------------------


provider "google" {
  project     = var.google_terraform_project
  region      = var.google_region
  zone        = var.google_zone
  credentials = file(var.google_credentials)
}



provider "googleworkspace" {
  customer_id             = var.google_customer_id
  impersonated_user_email = var.google_impersonated_user_email
  credentials             = file(var.google_credentials)
  oauth_scopes            = var.google_oauth_scopes 
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
# MODULE REFERENCE
# sets variables defined in module and can set in variables.tf, see module at source for explanation 
#-------------------------------------------------------------------------------------------------------------------------------------

module "google-cloud" {
  source           = "github.com/my-gh-account/infrastructure-modules//google-cloud?ref=v0.0.2"
  app_name          = var.google_cloud_app_name
  app_display_name  = var.google_cloud_app_display_name
  accounts          = var.google_cloud_accounts
  app_settings_json = var.google_cloud_app_settings_json
}

module "google-workspaces" {
  source           = "github.com/my-gh-account/infrastructure-modules//google-workspaces?ref=v0.0.2"
  app_name          = var.google_workspaces_app_name
  app_display_name  = var.google_workspaces_app_display_name
  accounts          = var.google_workspaces_accounts
  app_settings_json = var.google_workspaces_app_settings_json
}
