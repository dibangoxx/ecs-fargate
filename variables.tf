variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "region for our ecs"

}

variable "az_count" {
  type        = string
  default     = "3"
  description = "number of availability zones"

}

variable "ecs_task_execution_role" {
  type        = string
  default     = "MyEcsTaskExecutionRole"
  description = "name for ECS Task Execution"

}

variable "app_image" {
  type        = string
  default     = "nginx:1.25.0-alpine"
  description = "docker image to run in the ecs cluster"

}

variable "app_port" {
  type        = string
  default     = "80"
  description = "port for exposing our nginx image"

}

variable "app_count" {
  type        = string
  default     = "3"
  description = "number of containers to run"

}

variable "health_check_path" {
  default = "/"

}

variable "fargate_cpu" {
  default     = "1024"
  description = "fargate instance CPU units to provision, 1 vcpu of 1024"

}

variable "fargate_memory" {
  type    = string
  default = "2048"

}

variable "cidr_block" {
    type = string
    default = "172.16.0.0/16"
  
}
