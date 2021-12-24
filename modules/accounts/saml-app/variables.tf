variable "app" {
  type = string
}

variable "okta-appname" {
  type = string
}

variable "accounts" {
  type = list(string)
}

variable "groups" {
  type = list(map(string))
}

variable "app_settings_json" {
  type    = map(any)
  default = {}
}

variable "app_links_json" {
  type    = map(bool)
  default = {}
}

variable "profile" {
  type   = map(any)
  default = {}
}
