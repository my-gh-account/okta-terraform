#-------------------------------------------------------------------------------------------------------------------------------------
# OKTA S3 BACKEND
# There's a number of reasons to use a backend instead of a local state, this is to use the specified key in s3 backend
#-------------------------------------------------------------------------------------------------------------------------------------

terraform {
  backend "s3" {
    key = "staging/accounts/okta-groups/terraform.tfstate"
  }
}


#-------------------------------------------------------------------------------------------------------------------------------------
# OKTA PROVIDER VERSION REQUIREMENTS 
# Okta's resource requires you specify this version to work
#-------------------------------------------------------------------------------------------------------------------------------------

terraform {
  required_providers {
    okta = {
      source  = "okta/okta"
      version = "~> 3.20"
    }
  }
}

#-------------------------------------------------------------------------------------------------------------------------------------
# AWS PROVIDER MODULE
# Lets us use AWS resources
#-------------------------------------------------------------------------------------------------------------------------------------

provider "aws" {
  region = "us-east-2"
}

#-------------------------------------------------------------------------------------------------------------------------------------
# VAULT VARIABLES 
# Refers to variables for Hashicorp Vault in variables.tf
#-------------------------------------------------------------------------------------------------------------------------------------

provider "vault" {
  address = var.vault_address
}

data "vault_generic_secret" "okta_creds" {
  path = var.vault_secret_path
}


#-------------------------------------------------------------------------------------------------------------------------------------
# OKTA CREDENTIALS
# allows login to okta, api_token pointing here to data source created for hashicorp vault secure secret storage
#-------------------------------------------------------------------------------------------------------------------------------------

provider "okta" {
  org_name  = "teramindpputman"
  base_url  = "okta.com"
  api_token = data.vault_generic_secret.okta_creds.data["api_token"]
}


#-------------------------------------------------------------------------------------------------------------------------------------
# OKTA RBAC RULES TO GROUP MAPPING 
# This is where you can specify the name of the app you're giving access to, along with the RBAC rule.  Inside the okta-groups module
# this will create a rule named app-rulename.  For aws, specify rule name as aws-ACCOUNTID-IAMPolicy to have them automatically mapped
# to a role generated for this group, with the same name as the policy it will attach to.  The aws app policy will error out if you
# specify a role name for terraform configured aws account that doesn't exist, so we don't end up creating lots of misconfigured
# iam roles accidentally
#-------------------------------------------------------------------------------------------------------------------------------------

module "okta-groups" {
  source = "../../../modules/accounts/okta-groups/"

  aws_saml_app_filter    = var.aws_saml_app_filter
  aws_saml_provider_name = var.aws_saml_provider_name
 



  apps = {
    "Salesforce"            = { rule = "user.department == \"Sales\" OR user.department == \"Marketing\"" },
    "aws-384338-FullAccess" = { rule = "user.email == \"putman.patrick@gmail.com\"" },
    "aws-test-FullAccess"   = { rule = "user.email == \"putman.patrick@gmail.com\"" },
    "aws-975678609170-AdministratorAccess" = { rule = join(" ", [ # This join gives us a better way to specify larger, more complex rules on multiple lines.
      "user.email == \"putman.patrick@gmail.com\" OR",            # Admin
      "user.email == \"sally@example.com\"        OR",            # CTO      
      "user.email == \"bob@example.com\""
      ])
    },
    "aws-975678609170-test_policy2" = { rule = "user.email == \"putman.patrick@gmail.com\"" },
    "aws-975678609170-test_policy"  = { rule = "user.email == \"putman.patrick@gmail.com\"" },
  }

}
