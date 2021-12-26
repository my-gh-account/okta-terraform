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
  default     = "aws"
}

variable "app_display_name" {
  description = "Display name in okta webui for the app"
  type        = string
  default     = "AWS"
}


#-------------------------------------------------------------------------------------------------------------------------------------
# ASSIGNMENTS TO THE AWS APP
# This lets you specify another name for the trusted identity provider in AWS if desired, fine to leave as default otherwise.
#-------------------------------------------------------------------------------------------------------------------------------------

variable "aws_saml_provider_name" {
  description = "The name of the SAML provider (trusted identity provider) to create in aws/iam"
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
  description = "Filters which source of users can sign into aws, default set to only native okta users"
  type        = string
  default     = "okta"
}


variable "accounts" {
  description = "Array of account names or domains for the app"
  type        = map(any)
  default = {
    "975678609170" = {
      app_links_json = {
        login     = true
      },


    },
  }
}
