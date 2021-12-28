#-------------------------------------------------------------------------------------------------------------------------------------
# VERSION REQUIREMENTS 
# Versions of Teraform and its providers pinned for stability
#-------------------------------------------------------------------------------------------------------------------------------------

terraform {
  required_version = "~> 1.1.0"
  required_providers {
    okta = {
      source  = "okta/okta"
      version = "~> 3.20.2"
    }
  }
}


resource "okta_app_saml" "saml_app" {
  for_each            = var.accounts
  app_links_json      = try(jsonencode(each.value.app_links_json), "{}")
  app_settings_json   = jsonencode(each.value.app_settings_json != "" ? merge({ domain = each.key }, each.value.app_settings_json) : { domain = each.key })
  label               = "${each.value.app_display_name} ${each.key}"
  preconfigured_app   = each.value.okta_appname
  default_relay_state = try(each.value.default_relay_state, "")
  features            = []
  lifecycle {
    ignore_changes = [users, groups, app_settings_json]
  }
}

locals {
  groups_merged_with_app_id = {for key, account in var.accounts : key => merge(account, { for name, app in okta_app_saml.saml_app : "app_id" => app.id if name == key }) if length(account.groups) != 0 }
}

resource "okta_app_group_assignments" "app_assignments" {
  for_each = {for name, account in local.groups_merged_with_app_id : name => account }
  app_id     = each.value.app_id
  depends_on = [okta_app_saml.saml_app]

  dynamic "group" {
    for_each = each.value.groups
    content {
      id = group.value.id
    }
  }
}

data "okta_app_user_assignments" "app-users" {
  for_each  = okta_app_saml.saml_app
  id = each.value.id
}

output "app-users" {
  value = data.okta_app_user_assignments.app-users
}
