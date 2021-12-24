
variable "app" {
  type = string
  default = "slack"
}

variable "accounts" {
  type = list(string)
}

variable "app_settings_json" {
  type    = map(any)
  default = {}
}

variable "app_links_json" {
  type    = map(bool)
  default = {
    slack_ink = true
  }
}
