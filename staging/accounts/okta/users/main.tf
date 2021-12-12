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


resource "okta_app_saml" "aws_federation" {
}






##################### User Types #############################



resource "okta_user_type" "super_admin" {
  name         = "Super_Admin"
  display_name = "Super_Admin"
  description  = "Superest of Admins"

}

#################### Custom Properties  ############################

resource "okta_user_schema_property" "awesomeness" {
  index  = "awesomeness"
  title  = "awesomeness"
  type   = "string"
  master = "PROFILE_MASTER"
}



###################  Users  #########################################


###################  UserOne ########################################


resource "okta_user" "UserOne" {
  first_name = "User"
  last_name  = "One"
  login      = "userone@testemail.com"
  email      = "userone@testemail.com"
  custom_profile_attributes = jsonencode({ "awesomeness" = "super_awesome_dude" })
  lifecycle {
    ignore_changes = [group_memberships]
  }


  depends_on = [okta_user_schema_property.awesomeness]
}






################### User Two #######################################




resource "okta_user" "UserTwo" {
  first_name = "User"
  last_name  = "Two"
  login      = "usertwo@testemail.com"
  email      = "usertwo@testemail.com"
  custom_profile_attributes = jsonencode({ "awesomeness" = "super_awesome_dude" })
  lifecycle {
    ignore_changes = [group_memberships]
  }


  depends_on = [okta_user_schema_property.awesomeness]
}

resource "okta_user" "UserThree" {
  first_name = "User"
  last_name  = "Three"
  login      = "userthree@testemail.com"
  email      = "userthree@testemail.com"
  custom_profile_attributes = jsonencode({ "awesomeness" = "super_awesome_dude" })
  lifecycle {
    ignore_changes = [group_memberships]
  }


  depends_on = [okta_user_schema_property.awesomeness]
}

resource "okta_user" "UserFour" {
  first_name = "User"
  last_name  = "Four"
  login      = "userfour@testemail.com"
  email      = "userfour@testemail.com"
  custom_profile_attributes = jsonencode({ "awesomeness" = "super_awesome_dude" })
  lifecycle {
    ignore_changes = [group_memberships]
  }


  depends_on = [okta_user_schema_property.awesomeness]
}

resource "okta_user" "UserFive" {
  first_name = "User"
  last_name  = "Five"
  login      = "userfive@testemail.com"
  email      = "userfive@testemail.com"
  custom_profile_attributes = jsonencode({ "awesomeness" = "super_awesome_dude" })


  lifecycle {
    ignore_changes = [group_memberships]
  }


  depends_on = [okta_user_schema_property.awesomeness]
}





