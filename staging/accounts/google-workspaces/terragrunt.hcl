include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "github.com/my-gh-account/infrastructure-modules//google-workspaces"

}

dependencies {
  paths = ["../okta-users", "../okta-groups"]
}


inputs = {
  app_display_name  = "Google"
  okta_app          = "google"

  accounts = {
    "deserthomescleaning.com" = {
      app_links_json = {
        accounts = true
        calendar = true
        drive    = true
        keep     = false
        mail     = true
        sites    = false
      }
    }
  }
}
