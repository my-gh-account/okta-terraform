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
# OKTA DYNAMIC USER CREATOR 
# Speciy user in variable in live module to create.
#-------------------------------------------------------------------------------------------------------------------------------------

resource "okta_user" "user" {
  count      = length(var.okta_users)
  first_name = var.okta_users[count.index].first_name
  last_name  = var.okta_users[count.index].last_name
  login      = var.okta_users[count.index].login
  email      = var.okta_users[count.index].email
  lifecycle {
    ignore_changes = [group_memberships, admin_roles]
  }
}

