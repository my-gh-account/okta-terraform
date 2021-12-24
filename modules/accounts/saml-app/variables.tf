variable "app" {
  type = string
}

variable "okta-appname" {
  type = string
}

variable "accounts" {
  type = list(string)
  default = []
}

variable "groups" {
  type = list(map(string))
}

variable "app_settings_json" {
  type    = map(any)
}

variable "app_links_json" {
  type    = map(bool)
}
