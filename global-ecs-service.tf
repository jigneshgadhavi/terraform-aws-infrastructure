resource "aws_ecs_service" "default" {
  name            = "default"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = 1
  iam_role        = aws_iam_role.ecs-service-role.name
  depends_on      = [aws_lb_target_group.global_alb_tg]

  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.global_alb_tg.arn
    container_name   = "Nginx"
    container_port   = 8888
  }

  enable_ecs_managed_tags = true
  propagate_tags          = "SERVICE"

  tags = {
    Stack       = "devser"
    ServiceType = "Default"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_ecs_service" "pma" {
  name            = "phpmyadmin"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.pma_task_definition.arn
  desired_count   = 1
  iam_role        = aws_iam_role.ecs-service-role.name
  depends_on      = [aws_lb_target_group.pma_alb_tg]

  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.pma_alb_tg.arn
    container_name   = "phpmyadmin"
    container_port   = 80
  }

  enable_ecs_managed_tags = true
  propagate_tags          = "SERVICE"

  tags = {
    Stack       = "devser"
    ServiceType = "Default"
  }

  lifecycle {
    create_before_destroy = true
  }
}