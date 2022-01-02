#-------------------------------------------------------------------------------------------------------------------------------------
# HASHICORP VAULT VARIABLES 
# The vault server IP and Port, along with the path to our okta api token stored securely in vault
#-------------------------------------------------------------------------------------------------------------------------------------

variable "vault_address" {
  description = "Hashicorp Vault Server Address"
  type        = string
}

variable "vault_okta_secret_path" {
  description = "The path to access the okta credentials in Vault"
  type        = string
}

#-------------------------------------------------------------------------------------------------------------------------------------
# OKTA API CREDENTIALS
# Credentials for the okta api
#-------------------------------------------------------------------------------------------------------------------------------------

variable "okta_org_name" {
  description = "The okta account to connect to"
  type        = string
}

variable "okta_account_url" {
  description = "base okta url"
  type        = string
}

variable "api_token" {
  type    = string
}

#-------------------------------------------------------------------------------------------------------------------------------------
# GOOGLE PROVIDER CREDENTIALS
# Configuration for the google cloud
#-------------------------------------------------------------------------------------------------------------------------------------

variable "google_terraform_project" {
  description = "Google project for terraform"
  type        = string
}

variable "google_region" {
  type        = string
}

variable "google_zone" {
  type        = string
}

variable "google_customer_id" {
  type = string
}

variable "google_impersonated_user_email" {
  type = string
}

variable "google_credentials" {
  type = string
}

variable "google_oauth_scopes" {
  type = list(string)
}


#-------------------------------------------------------------------------------------------------------------------------------------
# GOOGLE CLOUD CONFIGURATION
# Configuration for the Google Cloud SAML  app
#-------------------------------------------------------------------------------------------------------------------------------------

variable "google_cloud_app_name" {
  description = "Name to use in okta groups configuration to specify the app"
  type        = string
  default     = "gcp"
}

variable "google_cloud_app_display_name" {
  description = "Display name in okta webui for the app"
  type        = string
  default     = "Google Cloud"
}

variable "google_cloud_app_settings_json" {
  type    = map(any)
  default = {}
}

variable "google_cloud_accounts" {
  description = "Array of account names or domains for the app"
  type        = map(any)
  default = {
    "deserthomescleaning.com" = {
      default_relay_state = "https://console.cloud.google.com"
      app_links_json = {
        cloudconsole_link = true
      }
    }
  }
}


#-------------------------------------------------------------------------------------------------------------------------------------
# GOOGLE  WORKSPACES CONFIGURATION
# Configuration for Google Workspaces SAML  App
#-------------------------------------------------------------------------------------------------------------------------------------

variable "google_workspaces_app_name" {
  description = "Name to use in okta groups configuration to specify the app"
  type        = string
  default     = "google"
}

variable "google_workspaces_app_display_name" {
  description = "Display name in okta webui for the app"
  type        = string
  default     = "Google Workspaces"
}

variable "google_workspaces_app_settings_json" {
  type    = map(any)
  default = {}
}

variable "google_workspaces_accounts" {
  description = "Array of account names or domains for the app"
  type        = map(any)
  default = {
    "deserthomescleaning.com" = {
      app_links_json = {
        accounts = true
        calendar = true
        drive    = true
        keep     = false
        mail     = true
        sites    = false
      }
    }
  }
}
