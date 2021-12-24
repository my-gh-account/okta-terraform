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

resource "okta_app_saml" "saml-app" {
  for_each          = toset(var.accounts)
  app_links_json    = jsonencode(var.app_links_json)
  app_settings_json = jsonencode(var.app_settings_json != "" ? merge({ domain = each.key }, var.app_settings_json) : { domain = each.key })
  label             = each.key
  preconfigured_app = var.okta-appname
  #features          = []
  profile           = jsonencode(var.profile)
  lifecycle {
    ignore_changes = [users, groups, app_settings_json]
  }
}

locals {
   groups_merged_with_app_id = [for group in var.groups : merge(group, { for app in okta_app_saml.saml-app : "app_id" => app.id if app.label == group.account} ) ]
}


resource "okta_app_group_assignments" "app-assignments" {
  for_each  =  { for group in local.groups_merged_with_app_id : group.name => group }
  app_id     = each.value.app_id
  depends_on = [okta_app_saml.saml-app]
  
  group {
    priority = 1
    id       = each.value.id
  }
}

output "group_assignments" {
  value = local.groups_merged_with_app_id
}

output "saml-metadata" {
  value = okta_app_saml.saml-app
}
