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

variable "okta_org_name" {
  description = "The okta account to connect to"
  type        = string
}

variable "okta_account_url" {
  description = "base okta url"
  type        = string
}


#-------------------------------------------------------------------------------------------------------------------------------------
# OKTA APP NAMES
# The okta app_name is the name we map to in the okta group rules, and the app_display_name is the name to display to users 
# in the app in OKTA
#-------------------------------------------------------------------------------------------------------------------------------------

variable "app_name" {
  description = "Name to use in okta groups configuration to specify the app"
  type        = string
  default     = "slack"
}

variable "app_display_name" {
  description = "Display name in okta webui for the app"
  type        = string
  default     = "Slack"
}

#-------------------------------------------------------------------------------------------------------------------------------------
# CONFIGURATION SETTINGS FOR OKTA APPLICATION  
# specify the accounts we're going to create applications for, and the custom settings for that application or account
#-------------------------------------------------------------------------------------------------------------------------------------

variable "app_settings_json" {
  type    = map(any)
  default = {}
}

variable "accounts" {
  description = "Array of account names or domains for the app"
  type        = map(any)
  default = {
    "deserthomescleaning" = {
      app_links_json = {
        slack_ink = true
      },
#      "security_team" = {
#        app_links_json = {
#          slack_ink = true
#        },
#      }
    }
  }
}
