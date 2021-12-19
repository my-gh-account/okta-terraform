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
   for_each    = { for user in var.okta_users : user.login => user } 
   first_name  = each.value.first_name
   last_name   = each.value.last_name
   login       = each.value.login
   email       = each.value.email
  lifecycle {
    ignore_changes = [group_memberships, admin_roles]
  }
}

output "okta_user" {
  value = toset(var.okta_users)
}
