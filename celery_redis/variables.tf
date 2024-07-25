
variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "instance_type" {
  description = "Instance type for the Celery and Redis EC2 instance"
  type        = string
  default     = "t2.micro"  # Default value if needed
}
