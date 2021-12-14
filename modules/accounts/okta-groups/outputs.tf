output "AWSFullAccessMembership" {
	value = okta_group_memberships.AWSFullAccess.id
}

output "S3FullMembership" {
	value = okta_group_memberships.S3Full.id
}

output "user_name" {
  value = toset([
    for user in okta_group_users : bd.name
  ])
}
