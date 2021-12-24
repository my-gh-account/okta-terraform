
variable "app" {
  type = string
  default = "google"
}

variable "okta-appname" {
  type = string
  default = "google"
}


variable "accounts" {
  type = list(string)
}

variable "app_settings_json" {
  type    = map(any)
  default = {}
}


variable "app_links_json" {
  type = map(bool)
  default = {
    accounts : true
    calendar : true
    drive    : true
    keep     : false
    mail     : true
    sites    : false
  }
}
