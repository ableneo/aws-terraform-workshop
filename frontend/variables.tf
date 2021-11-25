variable "app_name" {
  type        = string
  description = "Name of the app"
}
variable "git_repo" {
  type        = string
  description = "Git repo with the app"
}
variable "backend_url" {
  type        = string
  description = "Backend url"
}
variable "environment_name" {
  type        = string
  default     = "test"
}
variable "git_access_token" {
  type        = string
}
