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
}

module "app" {
  source = "./backend/app"

  cluster_id = module.ecs-cluster.cluster_id
  container_name = var.container_name
  container_port = var.container_port
  image_name = var.image_name
  image_tag = var.image_tag
  loadbalancer_arn = module.loadbalancer.loadbalancer_arn
  service_name = var.service_name
}
