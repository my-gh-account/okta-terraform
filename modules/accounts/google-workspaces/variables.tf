#variable "workspaces" {
#  description = "List of valid google domains"
#  type        = list(string)
#}

variable "app" {
  type = string
}

variable "accounts" {
  type = list(any)
}

variable "app_settings_json" {
  type    = map(any)
  default = {}
}

variable "app_links_json" {
  type    = map(bool)
  default = {}
}
