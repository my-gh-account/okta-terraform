#-------------------------------------------------------------------------------------------------------------------------------------
# OKTA USER 
# List of Objects to create thes specified users
#-------------------------------------------------------------------------------------------------------------------------------------


variable "okta_users" {
  type = list(object({
    first_name = string
    last_name  = string
    login      = string
    email      = string
  }))
}
