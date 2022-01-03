include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "github.com/my-gh-account/infrastructure-modules//google-cloud"
}

dependencies {
  paths = ["../okta-users", "../okta-groups", "../google-workspaces"]
}


inputs = {
  app_name           = "gcp"
  app_display_name   = "Google Cloud"
  okta_app           = "gcp"
  app_settings_json = {}

  accounts = {
    "deserthomescleaning.com" = {
      default_relay_state = "https://console.cloud.google.com"
      app_links_json = {
        cloudconsole_link = true
      }
    }
  }
}
