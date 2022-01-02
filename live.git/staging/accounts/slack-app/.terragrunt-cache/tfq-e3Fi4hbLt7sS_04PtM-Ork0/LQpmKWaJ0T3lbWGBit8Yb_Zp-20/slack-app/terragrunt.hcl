include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "github.com/my-gh-account/infrastructure-modules//slack-app"
}

dependencies {
  paths = ["../okta-users", "../okta-groups"]
}

inputs = {

 app_name  = "slack"
 app_display_name = "Slack"
 okta_appname = "slack"
 app_settings_json = {}

 accounts = {
    "deserthomescleaning" = {
      app_links_json = {
        slack_ink = true
      }
    }
  }
}
