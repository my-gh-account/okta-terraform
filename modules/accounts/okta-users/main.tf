terraform {
  required_providers {
    okta = {
      source  = "okta/okta"
      version = "~> 3.20"
    }
  }
}






resource "okta_user" "user" {
  count = "${length(var.okta-users)}"
  first_name  = "${var.okta-users[count.index].first_name}"
  last_name  = "${var.okta-users[count.index].last_name}"
  login  = "${var.okta-users[count.index].login}"
  email  = "${var.okta-users[count.index].email}"
  lifecycle {
    ignore_changes = [group_memberships, admin_roles]
  }
}


