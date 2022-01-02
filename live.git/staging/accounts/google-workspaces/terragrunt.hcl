include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "github.com/my-gh-account/infrastructure-modules//google-workspaces"

}

inputs = {
  app_name          = "google"
  app_display_name  = "google"
  okta_app          = "google"

  google_workspace_accounts = {
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
