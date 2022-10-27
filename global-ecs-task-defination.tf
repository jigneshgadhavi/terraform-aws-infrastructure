resource "aws_ecs_task_definition" "task_definition" {
  execution_role_arn       = aws_iam_role.ecs_tasks_execution_role.arn
  family                   = "default"
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]
  task_role_arn            = aws_iam_role.ecs_tasks_execution_role.arn

  container_definitions = jsonencode([
    {
      name             = "Nginx"
      image            = "${aws_ecr_repository.ecr-default.repository_url}"
      cpu              = 8
      memory           = 8
      essential        = true
      workingDirectory = "/usr/src/wordpress"
      portMappings = [
        {
          containerPort = 8888
          hostPort      = 8888
        }
      ],
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "secretOptions" : null,
        "options" : {
          "awslogs-group" : "/default",
          "awslogs-region" : "us-east-1",
          "awslogs-stream-prefix" : "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_task_definition" "pma_task_definition" {
  execution_role_arn       = aws_iam_role.ecs_tasks_execution_role.arn
  family                   = "phpmyadmin"
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]
  task_role_arn            = aws_iam_role.ecs_tasks_execution_role.arn

  container_definitions = jsonencode([
    {
      name             = "phpmyadmin"
      image            = "${aws_ecr_repository.ecr-pma.repository_url}"
      cpu              = 128
      memory           = 128
      essential        = true
      "environment" : [
        {
          "name" : "PMA_HOST",
          "value" : "${aws_db_instance.rds.endpoint}"
        }
      ]
      portMappings = [
        {
          containerPort = 80
          hostPort      = 0
        }
      ],
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "secretOptions" : null,
        "options" : {
          "awslogs-group" : "/pma",
          "awslogs-region" : "us-east-1",
          "awslogs-stream-prefix" : "ecs"
        }
      }
    }
  ])
}