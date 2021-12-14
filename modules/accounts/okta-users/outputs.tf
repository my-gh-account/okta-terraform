#output "AWSFullAccessMembership" {
#	value = okta_group_memberships.AWSFullAccess.id
#}
#
#output "S3FullMembership" {
#	value = okta_group_memberships.S3Full.id
#}
#
#output "target-groups-arn" {
#  value = values(okta_users.)[*].id
#}

#output "okta_users" {
#  value = "[${okta_user.users.*.id}]"
#}



