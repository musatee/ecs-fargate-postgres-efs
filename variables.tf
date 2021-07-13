# variables.tf

variable "aws_region" {
  description = "The AWS region things are created in"
  default     = "ap-south-1"
}

variable "ecs_task_execution_role_name" {
  description = "ECS task execution role name"
  default = "myEcsTaskExecutionRole"
}
