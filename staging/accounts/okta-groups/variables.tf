#-------------------------------------------------------------------------------------------------------------------------------------
# HASHICORP VAULT VARIABLES 
# The vault server IP and Port, along with the path to our okta api token stored securely in vault
#-------------------------------------------------------------------------------------------------------------------------------------

variable "vault_address" {
  description = "Hashicorp Vault Server Address"
  type        = string
  default     = "http://127.0.0.1:8200"
}

variable "vault_secret_path" {
  description = "The path to access the okta credentials in Vault"
  type        = string
  default     = "secret/okta_creds"

}


#-------------------------------------------------------------------------------------------------------------------------------------
# ASSIGNMENTS TO THE AWS APP
# This lets you specify another name for the trusted identity provider in AWS if desired, fine to leave as default otherwise.
#-------------------------------------------------------------------------------------------------------------------------------------

variable "aws_saml_provider_name" {
  description = "Name of the trusted identity provider in aws, can leave as default"
  type        = string
  default     = "Okta-SSO"
}


#-------------------------------------------------------------------------------------------------------------------------------------
# AWS FILTER FOR ORIGIN APPS 
# This refuses to let user accounts from other sources than aren't okta use this app to gain access to AWS.  Changing this will
# let you let users from another app, for instance Active Directory defined users, access AWS.  This is a security risk because if
# Someone who has admin privileges in AD, but not in Okta, creates an AD group named in a way that matches the role mapping regex,
# It will forward it through, granting them access to the specified role (and thus policy) in AWS.
#-------------------------------------------------------------------------------------------------------------------------------------

variable "aws_saml_app_filter" {
  description = "Name of app filter, if unsure, leave as default"
  type        = string
  default     = "okta"
}

#-------------------------------------------------------------------------------------------------------------------------------------
# RULE TO GROUP VARIABLE
# Rule to map okta users to groups specified by their APP, in okta, with Okta RBAC
#-------------------------------------------------------------------------------------------------------------------------------------
variable "apps" {
  type = map(
    map(string)
  )
}
