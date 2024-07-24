variable "db_name" {
  description = "The name of the database"
  type        = string
  default     = "mydatabase"
}

variable "db_username" {
  description = "The username for the database"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "The password for the database"
  type        = string
  default     = "password"
}

variable "subnet_ids" {
  description = "List of subnet IDs for the database subnet group."
  type        = list(string)
}

variable "vpc_id" {
  description = "The VPC ID where the resources will be created."
  type        = string
}