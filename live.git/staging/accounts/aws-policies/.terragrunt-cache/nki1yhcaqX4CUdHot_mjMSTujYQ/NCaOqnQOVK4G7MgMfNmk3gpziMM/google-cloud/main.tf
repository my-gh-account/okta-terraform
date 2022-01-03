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
    google = {
      source  = "hashicorp/google"
      version = "4.5.0"
    }
  }
}

#-------------------------------------------------------------------------------------------------------------------------------------
# DATA FOR ASSIGNMENTS TO APP AND GCP ROLES
# Local variables set the group app assignments (RBAC), the user app assignments (ABAC), the mapped users (role permissions in GCP)
# and the app configuration (per app/domain settings)
#-------------------------------------------------------------------------------------------------------------------------------------

#-------------------------------------------------------------------------------------------------------------------------------------
# OKTA ATTRIBUTE SEARCH
# Data source searches for the GcpRoles attribute and pulls users out
#-------------------------------------------------------------------------------------------------------------------------------------

data "okta_users" "gcpUsers" {
  search {
    name       = "profile.gcpRoles"
    value      = "roles"
    comparison = "sw"
  }
}


data "okta_groups" "okta_groups" {}


locals {

  cloud_app_configuration = { for name, account in var.accounts : name => merge(account, { "app_display_name" = var.app_display_name, app_settings_json = var.app_settings_json }) }

  #  cloud_app_groups            = [for group in data.okta_groups.okta_groups.groups : merge(group, { "role" = element(split("-", group.name), 3), "account_name" = element(split("-", group.name), 2) }) if(var.app_name == element(split("-", group.name), 1))]
  #  cloud_app_group_assignments = [for group in local.app_groups : group if contains(keys(var.accounts), group.account_name)]



  cloud_app_users            = flatten([for user in data.okta_users.gcpUsers.users : merge(user, jsondecode(user.custom_profile_attributes))])
  cloud_app_user_assignments = flatten([for user in local.cloud_app_users : distinct([for role in user.gcpRoles : { "user" = user.email, "account_name" = element(split("|", role), 1), "user_id" = user.id }])])
  cloud_role_assignments     = flatten([for user in local.cloud_app_users : [for role in user.gcpRoles : { "project" = element(split("|", role), 2), "account" = element(split("|", role), 1), "role" = element(split("|", role), 0), "user" = "user:${user.email}" } if contains(keys(var.accounts), element(split("|", role), 1))]])



}



#-------------------------------------------------------------------------------------------------------------------------------------
# GOOGLE CLOUD ROLE ASSIGNMENTS
# Maps Users with the GCP role setting in profile in okta to the proper roles/domain/project in google cloud
#-------------------------------------------------------------------------------------------------------------------------------------

resource "google_project_iam_member" "rolemapping" {
  for_each = { for assignment in local.cloud_role_assignments : "${assignment.user}-${assignment.account}-${assignment.role}-${assignment.project}" => assignment }
  member   = each.value.user
  role     = each.value.role
  project  = each.value.project
  # depends_on = [module.saml-app]
}


#-------------------------------------------------------------------------------------------------------------------------------------
# SAML APP MODULE
# Passes the app and assignment data to the saml app module for creation/assignment
#-------------------------------------------------------------------------------------------------------------------------------------
#
module "saml-app" {
  source            = "../saml-app/"
  accounts          = var.accounts
  okta_appname      = var.okta_appname
  app_configuration = local.cloud_app_configuration
  user_assignments  = local.cloud_app_user_assignments
  #  group_assignments = local.cloud_app_group_assignments
}
