variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "name" {
  type        = string
  description = "Base name for resources"
  default     = "moltbot"
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "image" {
  type        = string
  description = "Moltbot Docker image"
  default     = "moltbot/moltbot:latest"
}

variable "cpu" {
  type    = number
  default = 512
}

variable "memory" {
  type    = number
  default = 1024
}

variable "env_vars" {
  type    = map(string)
  default = {}
}
