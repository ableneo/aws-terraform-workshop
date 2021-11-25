resource "aws_ecr_repository" "app_repo" {
  name                 = var.image_name
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecs_task_definition" "app_task_definition" {
  network_mode             = "host"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  container_definitions = jsonencode([{
    name        = var.container_name
    image       = "${aws_ecr_repository.app_repo.repository_url}/${var.image_name}:${var.image_tag}"
    essential   = true
    portMappings = [{
      protocol      = "tcp"
      containerPort = var.container_port
      hostPort      = var.container_port
    }]
  }])

  family = "service"
}

resource "aws_lb_target_group" "app_tg" {
  name     = "${var.service_name}-tg"
  port     = 80
  protocol = "HTTP"
}

resource "aws_ecs_service" "app_service" {
  name                               = var.service_name
  cluster                            = var.cluster_id
  task_definition                    = aws_ecs_task_definition.app_task_definition.arn
  desired_count                      = 1
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"

  load_balancer {
    target_group_arn = aws_lb_target_group.app_tg.arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = var.loadbalancer_arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}
