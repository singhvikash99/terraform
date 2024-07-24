# Declare variables in variables.tf
variable "vpc_id" {
  description = "The ID of the VPC where the load balancer is created."
  type        = string
}

variable "subnet_ids" {
  description = "The IDs of the subnets where the load balancer is deployed."
  type        = list(string)
}

variable "security_group_ids" {
  description = "The IDs of the security groups to associate with the load balancer."
  type        = list(string)
}