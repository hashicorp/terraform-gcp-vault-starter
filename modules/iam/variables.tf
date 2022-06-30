variable "key_ring_id" {
  type        = string
  description = "Self link of the KMS key ring"
}

variable "project_id" {
  type        = string
  description = "GCP project in which to launch resources"
}

variable "resource_name_prefix" {
  type        = string
  description = "Prefix for naming resources"
}

variable "tls_secret_id" {
  type        = string
  description = "Secret id/name given to the google secrets manager secret"
}
