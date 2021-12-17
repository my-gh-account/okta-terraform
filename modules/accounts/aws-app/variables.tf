variable "cluster_name" {
  description = "The name to use for all the cluster resources"
  type        = string
}

variable "backend_s3_bucket" {
  description = "The s3 bucket used for backend storage, to gather custom policy arns"
  type        = string
}

variable "backend_s3_bucket_region" {
  description = "region for the backend s3 bucket"
  type	      = string
}


variable "saml_provider" {
  type = string
}

variable "app_filter" {
  type = string
}

