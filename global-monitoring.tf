resource "aws_cloudwatch_metric_alarm" "asg_cpu_alarm_up" {
  alarm_name          = "asg_cpu_alarm_up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "60"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.ec2_cluster.name
  }

  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions     = [aws_autoscaling_policy.asg_policy_up.arn]
}

resource "aws_cloudwatch_log_group" "logs-1" {
  name              = "/default"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "logs-2" {
  name              = "/pma"
  retention_in_days = 30
}