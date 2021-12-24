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
  groups        = [for group in data.okta_groups.okta_groups.groups : group if(length(regexall("(?i)${var.app}", element(split("-", group.name), 1))) > 0)]
  accounts =  [ for group in local.groups : merge (group, {"account" = element(split("-", group.name), 2 )}) ]
  group_map = [for group in local.accounts : merge(group, { "perms" = element(split("-", group.name), 3 )}) if contains(var.accounts, group.account) ]

}


module "saml-app" {
  source            = "../../../modules/accounts/saml-app/"
  app               = var.app
  okta-appname      = var.okta-appname
  groups            = local.group_map
  accounts          = var.accounts
  app_links_json    = var.app_links_json
  app_settings_json = var.app_settings_json
}

output "group_assignments" {
  value = module.saml-app.group_assignments
}
