#-------------------------------------------------------------------------------------------------------------------------------------
# HASHICORP VAULT VARIABLES 
# The vault server IP and Port, along with the path to our okta api token stored securely in vault
#-------------------------------------------------------------------------------------------------------------------------------------

variable "vault_address" {
  description = "Hashicorp Vault Server Address"
  type        = string
  default     = "http://127.0.0.1:8200"
}

variable "vault_okta_secret_path" {
  description = "The path to access the okta credentials in Vault"
  type        = string
  default     = "secret/okta_creds"
}


#-------------------------------------------------------------------------------------------------------------------------------------
# OKTA API CREDENTIALS
# Credentials for the okta api
#-------------------------------------------------------------------------------------------------------------------------------------

variable "okta_org_name" {
  description = "The okta account to connect to"
  type        = string
  default     = "dev-64024424"
}

variable "okta_account_url" {
  description = "base okta url"
  type        = string
  default     = "okta.com"
}

variable "token" {
  type    = string
  default = "api_token"
}

#-------------------------------------------------------------------------------------------------------------------------------------
# GOOGLE CLOUD CONFIGURATION
# Configuration for the google cloud
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
# Configuration for Google Workspaces App
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
        mail     = false
        sites    = false
      }
    }
  }
}
