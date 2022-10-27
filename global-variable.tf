variable "stack_name" {
  type        = string
  description = "This will degine the name of the Application."
}

variable "aws_region" {
  type        = string
  description = "This will define AWS Region to create resoureces."
}

variable "image_id" {
  type        = string
  description = "This will define AMI ID"
  default     = "ami-07746edc1e65f4f84" # This images is for AWS Optimized ECS. Amazon2 X86
}

variable "instance-type" {
  type        = string
  description = "This is instance type"
  default     = "t3.small"
}

variable "cluser_name" {
  type        = string
  description = "This will be assign as ECS Cluster name"
}

variable "shared_cluster_name" {
  type        = string
  description = "This will be assign as ECS Cluster name"
}

variable "private_subnets_cidr" {
  type    = list(any)
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24"]
}

variable "availability_zones" {
  type    = list(any)
  default = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"]
}