# ECS CLuster
resource "aws_ecs_cluster" "app" {
  name = "app"
}

# The main service.
resource "aws_ecs_service" "nginx_service" {
  name            = "nginx"
  task_definition = aws_ecs_task_definition.nginx_td.arn
  cluster         = aws_ecs_cluster.app.id
  launch_type     = "FARGATE"

  desired_count = var.container_count

  load_balancer {
    target_group_arn = aws_lb_target_group.nginx_tg.arn
    container_name   = "nginx"
    container_port   = "80"
  }

  network_configuration {
    assign_public_ip = false

    security_groups = [
      aws_security_group.ecs.id
    ]

    subnets = [
      aws_subnet.private_a.id,
      aws_subnet.private_b.id,
    ]
  }
}

# Task definition
resource "aws_ecs_task_definition" "nginx_td" {
  family = "nginx"

  container_definitions = <<EOF
  [
    {
      "name": "nginx",
      "image": "nginx:latest",
      "portMappings": [
        {
          "containerPort": 80
        }
      ]
    }
  ]

EOF

  execution_role_arn = aws_iam_role.ecs_task_role.arn

  # These are the minimum values for Fargate containers.
  cpu                      = 256
  memory                   = 512
  requires_compatibilities = ["FARGATE"]

  # This is required for Fargate containers.
  network_mode = "awsvpc"
}

# Target group
resource "aws_lb_target_group" "nginx_tg" {
  name        = "nginx"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.app_vpc.id
  depends_on  = [aws_alb.nginx_alb]
}

# Application Load Balancer
resource "aws_alb" "nginx_alb" {
  name               = "nginx-lb"
  internal           = false
  load_balancer_type = "application"

  subnets = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id,
  ]

  security_groups = [
    aws_security_group.http.id
  ]

  depends_on = [aws_internet_gateway.igw]
}

# Listener(s)
resource "aws_alb_listener" "nginx_http" {
  load_balancer_arn = aws_alb.nginx_alb.id
  port              = "80"
  protocol          = "HTTP"
  depends_on        = [aws_lb_target_group.nginx_tg]

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx_tg.arn
  }
}
