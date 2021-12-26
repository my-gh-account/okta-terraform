#-------------------------------------------------------------------------------------------------------------------------------------
# VERSION REQUIREMENTS 
# Versions of Teraform and its providers pinned for stability
#-------------------------------------------------------------------------------------------------------------------------------------

terraform {
  required_version = "~> 1.1.0"
  required_providers {
    okta = {
      source  = "okta/okta"
      version = "~> 3.20"
    }
  }
}

#-------------------------------------------------------------------------------------------------------------------------------------
# DATA FOR OKTA_GROUPS/SLACK SPACES
# Pulls out the okta groups specified for google and filters the account names by workspsaces variable.  This is because the google
# provider has no api to redeploy the saml integration, so if all google groups are removed from okta, and we dynamically create
# the aplication based on existing groups, it will delete any app without an assigned group, and then to redeploy requires us to
# go back into the google api and recreate the saml integrtion.  We can dynamically create the assignemtns to it.
#-------------------------------------------------------------------------------------------------------------------------------------


data "okta_groups" "okta_groups" {}


locals {
  app_groups     = [for group in data.okta_groups.okta_groups.groups : group if(var.app_name == element(split("-", group.name), 1))]
  role_groups    = [for group in local.app_groups : merge(group, { "role" = element(split("-", group.name), 3) })]
  account_info   = { for name, account in var.accounts : name => merge(account, { "okta_appname" = var.okta_appname, "app_display_name" = var.app_display_name, app_settings_json = var.app_settings_json }) }
  account_groups = { for name, info in local.account_info : name => merge(info, { "groups" = [for group in local.role_groups : group if name == element(split("-", group.name), 2)] }) }
}






module "saml-app" {
  source   = "../../../modules/accounts/saml-app/"
  accounts = local.account_groups
}

