resource "aws_security_group" "alb_security" {
  name        = "alb_sg"
  description = "access to the ALB"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port        = var.app_port
    to_port          = var.app_port
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

#Traffic to ECS should come from ALB only
resource "aws_security_group" "ecs-tasks" {
  name        = "ecs_sg"
  description = "access to the ALB"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port        = var.app_port
    to_port          = var.app_port
    protocol         = "tcp"
    cidr_blocks      = [aws_security_group.alb_security.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}