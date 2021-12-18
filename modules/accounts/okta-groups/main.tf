terraform {
  required_providers {
    okta = {
      source  = "okta/okta"
      version = "~> 3.20"
    }
  }
}

provider "vault" {
  address = var.vault_address
}

data "vault_generic_secret" "okta_creds" {
  path = var.vault_path
}

provider "okta" {
  org_name  = var.okta_org_name
  base_url  = var.okta_base_url
  api_token = var.okta_api_token
}

resource "okta_group" "app" {
  for_each    = var.apps
  name        = "app-${each.key}"
  description = "Do Not Edit, RBAC"
  #Do not add users here, use rules only
}

resource "okta_group_rule" "app" {
  for_each          = var.apps
  name              = "rbac-app-${each.key}"
  status            = "ACTIVE"
  group_assignments = [okta_group.app[each.key].id]
  expression_type   = "urn:okta:expression:1.0"
  expression_value  = each.value.rule
  users_excluded    = []
}



