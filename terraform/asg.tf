resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = 4
  min_capacity       = 2
  resource_id        = "service/${aws_ecs_cluster.my_cluster.id}/${aws_ecs_service.my_service.id}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

# Scaledown Policy
resource "aws_appautoscaling_policy" "down" {
  name               = "scale-down"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  step_scaling_policy_configuration {
    adjustment_type = "ChangeInCapacity"
    cooldown        = 60

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1 #  A negative value scales down.
    }
  }
  depends_on = [
    aws_appautoscaling_target.ecs_target
  ]
}

# Scaleup Policy
resource "aws_appautoscaling_policy" "up" {
  name               = "scale-up"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  step_scaling_policy_configuration {
    adjustment_type = "ChangeInCapacity"
    cooldown        = 60

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1 # A positive value scales up.
    }
  }
  depends_on = [
    aws_appautoscaling_target.ecs_target
  ]
}


resource "aws_cloudwatch_metric_alarm" "cpu-high-alarm" {
  alarm_name          = "asg-cpu-high-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "80"

  dimensions = {
    cluster_name = "aws_ecs_cluster.my_cluster.name"
    service_name = "aws_ecs_service.my_service.name"
  }

  alarm_description = "This metric monitors container cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.up.arn]
}

resource "aws_cloudwatch_metric_alarm" "cpu-low-alarm" {
  alarm_name          = "asg-cpu-low-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "10"

  dimensions = {
    cluster_name = "aws_ecs_cluster.my_cluster.name"
    service_name = "aws_ecs_service.my-service.name"
  }

  alarm_description = "This metric monitors container cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.down.arn]
}