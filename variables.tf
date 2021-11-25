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
  type        = string
}
variable "image_tag" {
  type        = string
}
variable "image_name" {
  type        = string
}
variable "container_port" {
  type        = string
}
variable "container_name" {
  type        = string
}
variable "app_name" {
  type        = string
}
variable "frontend_app_repo" {
  type        = string
}
variable "git_access_token" {
  type        = string
}
