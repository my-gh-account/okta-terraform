output "AWSFullAccessMembership" {
	value = okta_group_memberships.AWSFullAccess.id
}

output "S3FullMembership" {
	value = okta_group_memberships.S3Full.id
}
