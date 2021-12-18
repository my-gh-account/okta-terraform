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

resource "okta_user" "user" {
  count      = length(var.okta-users)
  first_name = var.okta-users[count.index].first_name
  last_name  = var.okta-users[count.index].last_name
  login      = var.okta-users[count.index].login
  email      = var.okta-users[count.index].email
  lifecycle {
    ignore_changes = [group_memberships, admin_roles]
  }
}

