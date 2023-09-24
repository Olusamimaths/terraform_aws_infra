variable "region" {
  default     = "eu-west-2"
  type        = string
  description = "The AWS region to deploy to"
}

variable "namespace" {
  description = "Project namespace"
  type        = string
}

variable "project_name" {
  description = "The name of the project"
  type        = string
}

variable "ssh_key" {
  description = "Public key to EC2 instance"
  type        = string
}
