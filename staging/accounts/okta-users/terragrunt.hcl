include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "github.com/my-gh-account/infrastructure-modules//accounts/okta-users"
}

inputs = {
  okta_users = [
    {
      first_name = "Patrick"
      last_name  = "Putman"
      login      = "putman.patrick@gmail.com"
      email      = "putman.patrick@gmail.com"
    },
    {
      first_name = "Bob"
      last_name  = "Johnson"
      login      = "bob@example.com"
      email      = "bob@example.com"
    },
    {
      first_name = "Sally"
      last_name  = "Parker"
      login      = "sally@example.com"
      email      = "sally@example.com"
    },
    {
      first_name = "Test"
      last_name  = "User"
      login      = "test@deserthomescleaning.com"
      email      = "test@deserthomescleaning.com"
      custom_profile_attributes = {
        gcpRoles = ["roles/owner|deserthomescleaning.com|782936128004"]
        gwsRoles = ["_GROUPS_ADMIN_ROLE","_USER_MANAGEMENT_ADMIN_ROLE"]
        google   = ["deserthomescleaning.com"]
      }
    },
    {
      first_name = "Test"
      last_name  = "User"
      login      = "test2@deserthomescleaning.com"
      email      = "test2@deserthomescleaning.com"
      custom_profile_attributes = {
        gcpRoles = ["roles/iam.workloadIdentityPoolAdmin|deserthomescleaning.com|782936128004", "roles/cloudjobdiscovery.admin|deserthomescleaning.com|782936128004", "roles/owner|deserthomescleaning.com|782936128004"]
        gwsRoles = ["_GROUPS_ADMIN_ROLE"]
        google   = ["deserthomescleaning.com"]
      }
    },
  ]
}
