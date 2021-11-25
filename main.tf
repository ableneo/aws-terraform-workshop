terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region = var.region
}

module "ecs-cluster" {
  source = "./backend/cluster"

  cluster_name = var.cluster_name
}

module "loadbalancer" {
  source = "./backend/loadbalancer"

  lb_name = var.loadbalancer_name
  region = var.region
}

module "backend-app" {
  source = "./backend/app"

  cluster_id = module.ecs-cluster.cluster_id
  container_name = var.container_name
  container_port = var.container_port
  image_name = var.image_name
  image_tag = var.image_tag
  loadbalancer_arn = module.loadbalancer.loadbalancer_arn
  service_name = var.service_name
  vpc_id = module.loadbalancer.vpc_id
  subnets = module.loadbalancer.subnets
  security_group_id = module.loadbalancer.security_group_id
}

module "frontend-app" {
  source = "./frontend"

  app_name = var.app_name
  backend_url = module.loadbalancer.loadbalancer_url
  git_repo = var.frontend_app_repo
  git_access_token = var.git_access_token
}
