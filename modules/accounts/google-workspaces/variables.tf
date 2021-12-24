
variable "app" {
  type = string
}

variable "accounts" {
  #type = list(map(string))
  default = []
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
