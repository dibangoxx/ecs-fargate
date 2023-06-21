#Define AWS provider and region
provider "aws" {
  region = var.aws_region
}

data "template_file" "demoapp" {
  template = file("./templates/image/image.json")

  vars = {
    app_image      = var.app_image
    app_port       = var.app_port
    fargate_cpu    = var.fargate_cpu
    fargate_memory = var.fargate_memory
    aws_region     = var.aws_region
    vpc_id = aws_vpc.ecs_vpc.id
  }
}

# Create an ECS cluster
resource "aws_ecs_cluster" "app_ecs_cluster" {
  name = "app-ecs-cluster"
}

# Define task definition
resource "aws_ecs_task_definition" "app_task_def" {
  family                   = "app-ecs-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = data.template_file.testapp.rendered
}

# Define the container definition template
data "template_file" "testapp" {
  template = <<EOF
  [
    {
      "name": "app-ecs",
      "image": "${var.app_image}",
      "portMappings": [
        {
          "containerPort": ${var.app_port},
          "protocol": "tcp"
        }
      ]
    }
  ]
  EOF
}

# Create ECS service
resource "aws_ecs_service" "ecs_app_service" {
  name            = "app-ecs-service"
  cluster         = aws_ecs_cluster.app_ecs_cluster.id
  task_definition = aws_ecs_task_definition.app_task_def.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = aws_subnet.ecspublic_subnet.*.id
    security_groups  = [aws_security_group.ecs-server.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app_target_group.arn
    container_name   = "app-ecs"
    container_port   = var.app_port
  }

  depends_on = [aws_lb_listener.app_listener, aws_iam_role_policy_attachment.ecs_task_execution_role]
}