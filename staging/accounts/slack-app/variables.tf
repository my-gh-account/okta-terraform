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

variable "app" {
  type    = string
  default = "slack"
}

variable "workspaces" {
  type    = list(any)
  default = ["deserthomescleaning"]
}

#variable "app_settings_json" {
#  type = map
#  default = {
#    afwOnly : false
#  }
#}
#variable "app_links_json" {
#  type = map(bool)
#  default = {
#    accounts : true
#    calendar : true
#    drive    : true
#    keep     : false
#    mail     : true
#    sites    : false
#    }
#} 
  
