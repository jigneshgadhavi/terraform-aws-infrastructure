resource "aws_ecs_cluster" "cluster" {
  name = var.cluser_name
  tags = {
    name = "${var.cluser_name}-ecs-cluster"
  }
}

resource "aws_ecs_cluster_capacity_providers" "devser-ecs-cluster-cp" {
  cluster_name = aws_ecs_cluster.cluster.name

  capacity_providers = [aws_ecs_capacity_provider.devser-ecs-cp.name]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = aws_ecs_capacity_provider.devser-ecs-cp.name
  }
}

resource "aws_ecs_cluster" "shared_cluster_ecs" {
  name = var.shared_cluster_name
  tags = {
    name = "${var.shared_cluster_name}-ecs-cluster"
  }
}