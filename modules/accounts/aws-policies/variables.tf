variable "cluster_name" {
  description = "The name to use for all the cluster resources"
  type        = string
}


variable "policies" {
  type    = list(object({
    description = string
    name        = string
    path        = string
    tags        = map(string)
    policy      = string
  }))
}
