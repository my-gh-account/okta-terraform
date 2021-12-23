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


variable "workspaces" {
    description = "List of valid google workspaces"
    type        = list(string)
    default     = [ "deserthomescleaning.com" ] 

}
