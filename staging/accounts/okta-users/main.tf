#-------------------------------------------------------------------------------------------------------------------------------------
# OKTA S3 BACKEND
# There's a number of reasons to use a backend instead of a local state, this is to use the specified key in s3 backend
#-------------------------------------------------------------------------------------------------------------------------------------

terraform {
  backend "s3" {
    key = "staging/accounts/okta-users/terraform.tfstate"
  }
}


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
# OKTA CREDENTIALS
# allows login to okta, api_token pointing here to data source created for hashicorp vault secure secret storage
#-------------------------------------------------------------------------------------------------------------------------------------

provider "okta" {
  org_name  = var.okta_org_name
  base_url  = var.okta_account_url
  api_token = data.vault_generic_secret.okta_creds.data[var.api_token]
}



#-------------------------------------------------------------------------------------------------------------------------------------
# OKTA USER MODULE REFERENCE WITH DEFINED USERS 
# Define users below in same format.
#-------------------------------------------------------------------------------------------------------------------------------------

module "okta-users" {
  source = "../../../modules/accounts/okta-users/"
  okta_users = [
    {
      first_name = "Patrick"
      last_name  = "Putman"
      login      = "putman.patrick@gmail.com"
      email      = "putman.patrick@gmail.com"
    },
    {
      first_name = "Bob"
      last_name  = "Johnson"
      login      = "bob@example.com"
      email      = "bob@example.com"
    },
    {
      first_name = "Sally"
      last_name  = "Parker"
      login      = "sally@example.com"
      email      = "sally@example.com"
    },
    {
      first_name = "Test"
      last_name  = "User"
      login      = "test@deserthomescleaning.com"
      email      = "test@deserthomescleaning.com"
      custom_profile_attributes = {
        gcpRoles = ["roles/iam.workloadIdentityPoolAdmin|deserthomescleaning.com|782936128004"] #, "roles/cloudjobdiscovery.admin|deserthomescleaning.com|782936128004"]
      }
    },
    {
      first_name = "Test"
      last_name  = "User"
      login      = "test2@deserthomescleaning.com"
      email      = "test2@deserthomescleaning.com"
      custom_profile_attributes = {
        gcpRoles = ["roles/iam.workloadIdentityPoolAdmin|deserthomescleaning.com|782936128004", "roles/cloudjobdiscovery.admin|deserthomescleaning.com|782936128004"]
      }
    },

  ]
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

  apps = {
    #AWS Rules format:  aws-accountnumber-s3Policy
    "aws-975678609170-AdministratorAccess" = { rule = join(" ", [ # This join gives us a better way to specify larger, more complex rules on multiple lines.
      "user.email == \"putman.patrick@gmail.com\" OR",            # Admin
      "user.email == \"sally@example.com\"        OR",            # CTO      
      #"user.email == \"bob@example.com\"          OR",
      "user.email == \"test@deserthomescleaning.com\""
      ])
    },
    "aws-975678609170-test_policy3" = { rule = "user.email == \"putman.patrick@gmail.com\"" },
    "aws-975678609170-AmazonS3FullAccess" = { rule = join(" ", [ # This join gives us a better way to specify larger, more complex rules on multiple lines.
      "user.email == \"putman.patrick@gmail.com\" OR",           # Admin
      #      "user.email == \"sally@example.com\"        OR",           # CTO      
      #      "user.email == \"bob@example.com\"          OR",
      "user.email == \"test@deserthomescleaning.com\""
      ])
    },
    #Slack Rules Formation:  slack-workspace
    "slack-deserthomescleaning" = { rule = join(" ", [
      "user.email == \"putman.patrick@gmail.com\" OR",
      "user.email == \"test@deserthomescleaning.com\""
      ])
    },
    "slack-security_team" = { rule = join(" ", [
      "user.email == \"putman.patrick@gmail.com\" OR",
      "user.email == \"patrick@teramind.co\""
    ]) },
    #Google Workspaces
    #    "google-deserthomescleaning.com-test2" = { rule = join(" ", [
    #      "user.email == \"test@deserthomescleaning.com\" OR",
    #      "user.email == \"patrick@teramind.co\" OR ",
    #      "user.email == \"test2@deserthomescleaning.com\"",
    #      ])
    #    },
    #    "google-deserthome.com-test" = { rule = join(" ", [
    #      "user.email == \"patrick@deserthomescleaning.com\" OR",
    #      "user.email == \"test@deserthomescleaning.com\"",
    #      ])
    #    },
    #    "google-deserthomescleaning.com-test" = { rule = join(" ", [
    #      "user.email == \"test@deserthomescleaning.com\" OR",
    #      "user.email == \"patrick@teramind.co\" OR",
    #      "user.email == \"putman.patrick@gmail.com\" OR",
    #      "user.email == \"test2@deserthomescleaning.com\"",
    #      ])
    #    },
    #     # Google Cloud
    #    "gcp-deserthome.com-test" = { rule = join(" ", [
    #      "user.email == \"patrick@deserthomescleaning.com\" OR",
    #      "user.email == \"test@deserthomescleaning.com\" OR",
    #      "user.email == \"test2@deserthomescleaning.com\"",
    #
    #      ])
    #    },

  }
}

