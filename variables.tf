variable "region" {
  type        = string
  description = "AWS region"
}
variable "cluster_name" {
  type        = string
  description = "Name of the ECS cluster"
}
variable "loadbalancer_name" {
  description = "Name of the LB"
}
variable "service_name" {
}
variable "image_tag" {
}
variable "image_name" {
}
variable "container_port" {
}
variable "container_name" {
}
