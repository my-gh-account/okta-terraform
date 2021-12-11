terraform {
  required_providers {
    okta = {
      source  = "okta/okta"
      version = "~> 3.20"
    }
  }
}



#################### Admin Roles #######################

resource "okta_group_role" "GroupOneSuperAdmin" {
  group_id  = okta_group.GroupOne.id
  role_type = "SUPER_ADMIN"
}
resource "okta_group_role" "GroupTwoReadOnlyAdmin" {
  group_id  = okta_group.GroupTwo.id
  role_type = "READ_ONLY_ADMIN"
}


resource "okta_group_role" "GroupThreeUserAdmin" {
  group_id          = okta_group.GroupThree.id
  role_type         = "USER_ADMIN"
  target_group_list = [okta_group.GroupFour.id, okta_group.GroupTwo.id]
}


##################### Groups ############################

resource "okta_group" "GroupOne" {
  name        = "group 1"
  description = "My Test Group 1"
}

resource "okta_group" "GroupTwo" {
  name        = "group 2"
  description = "My Test Group 2"
}

resource "okta_group" "GroupThree" {
  name        = "group 3"
  description = "My Test Group 3"
}

resource "okta_group" "GroupFour" {
  name        = "group 4"
  description = "My Test Group 4"
}

##################### Types #############################



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

resource "okta_user" "UserOne" {
  first_name = "User"
  last_name  = "One"
  login      = "userone@testemail.com"
  email      = "userone@testemail.com"
  password_hash {
    algorithm = "MD5"
    value     = "098f6bcd4621d373cade4e832627b4f6"
  }
  custom_profile_attributes = jsonencode({ "awesomeness" = "super_awesome_dude" })
  lifecycle {
    ignore_changes = [group_memberships]
  }


  depends_on = [okta_user_schema_property.awesomeness]
}


resource "okta_user" "UserTwo" {
  first_name = "User"
  last_name  = "Two"
  login      = "usertwo@testemail.com"
  email      = "usertwo@testemail.com"
  password_hash {
    algorithm = "MD5"
    value     = "098f6bcd4621d373cade4e832627b4f6"
  }
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
  password_hash {
    algorithm = "MD5"
    value     = "098f6bcd4621d373cade4e832627b4f6"
  }
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
  password_hash {
    algorithm = "MD5"
    value     = "098f6bcd4621d373cade4e832627b4f6"
  }
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
  password_hash {
    algorithm = "MD5"
    value     = "098f6bcd4621d373cade4e832627b4f6"
  }
  custom_profile_attributes = jsonencode({ "awesomeness" = "super_awesome_dude" })


  lifecycle {
    ignore_changes = [group_memberships]
  }


  depends_on = [okta_user_schema_property.awesomeness]
}




######################## Memberships #############################33

resource "okta_group_memberships" "GroupmembersOne" {
  group_id = okta_group.GroupOne.id
  users = [
    okta_user.UserOne.id,
    okta_user.UserTwo.id,
  ]
}

resource "okta_group_memberships" "GroupmembersTwo" {
  group_id = okta_group.GroupTwo.id
  users = [
    okta_user.UserThree.id,
    okta_user.UserFour.id,
  ]
}


resource "okta_group_memberships" "GroupmembersThree" {
  group_id = okta_group.GroupThree.id
  users = [
    okta_user.UserFive.id,
    okta_user.UserOne.id,
  ]
}

resource "okta_group_memberships" "GroupmembersFour" {
  group_id = okta_group.GroupFour.id
  users = [
    okta_user.UserOne.id,
    okta_user.UserTwo.id,
    okta_user.UserThree.id,
    okta_user.UserFour.id,
    okta_user.UserFive.id,

  ]
}
