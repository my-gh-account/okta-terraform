variable "cluster_name" {
  description = "The name to use for all the cluster resources"
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
