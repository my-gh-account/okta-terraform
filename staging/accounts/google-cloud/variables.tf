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





variable "app_name" {
  description = "Name to use in okta groups configuration to specify the app"
  type        = string
  default     = "gcp"
}

variable "app_display_name" {
  description = "Display name in okta webui for the app"
  type        = string
  default     = "Google Cloud"
}





variable "app_settings_json" {
  type    = map(any)
  default = {}
}




variable "accounts" {
  description = "Array of account names or domains for the app"
  type        = map(any)
  default = {
    "deserthomescleaning.com" = {
      default_relay_state = "https://console.cloud.google.com"
      app_links_json = {
        cloudconsole_link = true

      },
    },
    "deserthome.com" = {
      default_relay_state = "https://console.cloud.google.com"
      app_links_json = {
        cloudconsole_link = true

      },

    }
    "deserthomes.com" = {
      default_relay_state = "https://console.cloud.google.com"
      app_links_json = {
        cloudconsole_link = true

      },

    }
  }
}

