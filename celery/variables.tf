variable "vpc_id" {
  description = "The VPC ID where the resources will be created."
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs to be used."
  type        = list(string)
}
