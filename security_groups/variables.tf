# Declare a variable for vpc_id in variables.tf
variable "vpc_id" {
  description = "The ID of the VPC where the security group is created."
  type        = string
}