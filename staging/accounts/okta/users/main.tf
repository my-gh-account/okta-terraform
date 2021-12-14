terraform {
  backend "s3" {
    key            = "staging/accounts/okta/users/terraform.tfstate"
  }
}

terraform {
  required_providers {
    okta = {
      source  = "okta/okta"
      version = "~> 3.20"
    }
  }
}




#################### Okta Admin Roles #######################



resource "okta_group_role" "SuperAdmins" {
  group_id  = okta_group.OktaSuperAdmin.id
  role_type = "SUPER_ADMIN"
}







###################### Okta Groups #############################

resource "okta_group" "OktaSuperAdmin" {
  name        = "OktaSuperAdmin"
  description = "OktaSuperAdmin"
}


resource "okta_group_memberships" "OktaSuperAdmin" {
  group_id = okta_group.OktaSuperAdmin.id
  users = [
	okta_user.PatrickPutman.id
    ]
}






###################### AWS Groups ###############################

resource "okta_group" "AWSFullAccess" {
  name        = "aws#security-team#FullAccess#975678609170"
  description = "Security Team"
}


resource "okta_group_memberships" "AWSFullAccess" {
  group_id = okta_group.AWSFullAccess.id
  users = [
	okta_user.PatrickPutman.id
    ]
}




resource "okta_group" "S3Full" {
  name        = "aws#storage-team#S3Full#975678609170"
  description = "StorageTeam"
}

resource "okta_group_memberships" "S3Full" {
  group_id = okta_group.S3Full.id
  users = [   
	okta_user.PatrickPutman.id
  ]
}





################### Users ######################################


resource "okta_user" "PatrickPutman" {
  first_name = "Patrick"
  last_name  = "Putman"
  login      = "putman.patrick@gmail.com"
  email      = "putman.patrick@gmail.com"
  lifecycle {
    ignore_changes = [group_memberships, admin_roles]
  }
}


