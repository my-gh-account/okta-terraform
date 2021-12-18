#-------------------------------------------------------------------------------------------------------------------------------------
# OKTA USER 
# List of Objects to create thes specified users
#-------------------------------------------------------------------------------------------------------------------------------------


#variable "okta_users" {
#  type = list(map({
#    first_name = string
#    last_name  = string
#    login      = string
#    email      = string
#  }))
#}


variable "okta_users" {
  type = list(map(string))
}
