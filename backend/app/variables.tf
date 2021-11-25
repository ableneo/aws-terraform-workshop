variable "container_name" {
  type        = string
  description = "Name of the container"
}

variable "image_name" {
  type        = string
  description = "Name of the image"
}

variable "image_tag" {
  type        = string
  description = "Tag of the image"
}

variable "container_port" {
  type        = number
  description = "Container port"
}

variable "service_name" {
  type        = string
  description = "Name of the service"
}

variable "cluster_id" {
  type        = string
  description = "Cluster ID"
}

variable "loadbalancer_arn" {
  type        = string
  description = "LB ARN"
}
