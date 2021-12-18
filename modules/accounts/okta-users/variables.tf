
variable "cluster_name" {
  description = "The name to use for all the cluster resources"
  type        = string
}

variable "vault_path" {
  description = "path to credentials in vault"
  type        = string
}

variable "vault_address" {
  description = "address to the vault"
  type        = string
}


variable "okta_org_name" {
  description = "okta org name"
  type        = string
}

variable "okta_base_url" {
  description = "okta base url"
  type        = string
}

variable "okta_api_token" {
  description = "okta api token"
  type        = string
}

variable "okta-users" {
  type = list(object({
    first_name = string
    last_name  = string
    login      = string
    email      = string
  }))
}
