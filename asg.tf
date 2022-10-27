# Devser ASG Configurations
resource "aws_autoscaling_group" "ec2_cluster" {
  name                      = var.cluser_name
  max_size                  = 4
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "EC2"
  target_group_arns         = aws_lb_target_group.global_alb_tg.arn[*]
  desired_capacity          = 2
  protect_from_scale_in     = true
  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]
  metrics_granularity  = "1Minute"
  force_delete         = true
  launch_configuration = aws_launch_configuration.ecs_asg_lc.name
  vpc_zone_identifier  = aws_subnet.main_vpc_subnet.*.id

  lifecycle {
    create_before_destroy = true
  }
  tag {
    key                 = "Name"
    value               = var.cluser_name
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "asg_policy_up" {
  name                   = "asg_policy_up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.ec2_cluster.name
}

resource "aws_ecs_capacity_provider" "devser-ecs-cp" {
  name = "${var.cluser_name}_cp"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.ec2_cluster.arn
    managed_termination_protection = "ENABLED"

    managed_scaling {
      maximum_scaling_step_size = 4
      minimum_scaling_step_size = 2
      status                    = "ENABLED"
      target_capacity           = 100
    }
  }
}

# Shared-Hosting ASG Configurations
resource "aws_autoscaling_group" "ec2_shared_cluster" {
  name                      = "${var.shared_cluster_name}_asg"
  max_size                  = 20
  min_size                  = 0
  health_check_grace_period = 300
  health_check_type         = "EC2"
  target_group_arns         = aws_lb_target_group.shared_alb_tg.arn[*]
  desired_capacity          = 0
  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]
  metrics_granularity  = "1Minute"
  force_delete         = true
  launch_configuration = aws_launch_configuration.shared_ecs_asg_lc.name
  vpc_zone_identifier  = aws_subnet.main_vpc_subnet.*.id

  lifecycle {
    create_before_destroy = true
  }
  tag {
    key                 = "Name"
    value               = var.shared_cluster_name
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "shared_asg_policy_up" {
  name                   = "shared_asg_policy_up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.ec2_shared_cluster.name
}