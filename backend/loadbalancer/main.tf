resource "aws_lb" "app_loadbalancer" {
  name               = var.lb_name
  internal           = false
  load_balancer_type = "application"

  enable_deletion_protection = true

  tags = {
    Environment = "test"
  }

}
