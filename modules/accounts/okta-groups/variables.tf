variable "cluster_name" {
  description = "The name to use for all the cluster resources"
  type        = string
}

variable "apps" {
  type = map(
       map(string)
  )
}

