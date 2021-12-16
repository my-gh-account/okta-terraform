terraform {
  required_providers {
    okta = {
      source  = "okta/okta"
      version = "~> 3.20"
    }
  }
}



##################### Okta Admin Roles #######################
#
#
#
#resource "okta_group_role" "SuperAdmins" {
#  group_id  = okta_group.OktaSuperAdmin.id
#  role_type = "SUPER_ADMIN"
#}
#






resource "okta_group" "app" {
 for_each = var.apps
    name        = "app-${each.key}"
    description = "Do Not Edit, RBAC"
    #Do not add users here, use rules only
}

resource "okta_group_rule" "app" {
 for_each = var.apps
    name              = "rbac-app-${each.key}"
    status            = "ACTIVE"
    group_assignments = [okta_group.app[each.key].id]
    expression_type   = "urn:okta:expression:1.0"
    expression_value  = each.value.rule
}








####################### AWS Groups ###############################
#
#resource "okta_group" "AWSFullAccess" {
#  name        = "aws#security-team#FullAccess#975678609170"
#  description = "Security Team"
#}
#
#
#resource "okta_group_memberships" "AWSFullAccess" {
#  group_id = okta_group.AWSFullAccess.id
#  users = [
#	okta_user.PatrickPutman.id
#    ]
#}
#
#
#
#
#resource "okta_group" "S3Full" {
#  name        = "aws#storage-team#S3Full#975678609170"
#  description = "StorageTeam"
#}
#
#resource "okta_group_memberships" "S3Full" {
#  group_id = okta_group.S3Full.id
#  users = [   
#	okta_user.PatrickPutman.id
#  ]
#}


