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
