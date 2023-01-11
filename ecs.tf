resource "aws_ecs_cluster" "my_cluster" {
  name = "Gawin's cluster"
}

resource "aws_ecs_task_definition" "app" {
  family = "service"
  container_definitions = jsonencode([
    {
      name      = "my-node-app"
      image     = "service-first"
      cpu       = var.fargate_cpu
      memory    = var.fargate_memory
      portMappings = [
        {
          containerPort = var.app_port
          hostPort      = var.app_port
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "mongo" {
  name            = "mongodb"
  cluster         = aws_ecs_cluster.my_cluster.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = var.app_count
  launch_type = "FARGATE"

  network_configuration {
    subnet = aws_subnet.my_subnet.id
    security_groups = [aws_security_group.ecs-tasks.id]
    assign_public_ip = true
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.my_target_group.arn
    container_name   = "my-node-app"
    container_port   = var.app_port
  }

    depends_on = [
      aws_lb_listener.front_end
    ]
}