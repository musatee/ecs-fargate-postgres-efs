# ecs.tf

resource "aws_ecs_cluster" "main" {
  name = "myapp-cluster"
}


resource "aws_ecs_service" "bar" {
  name             = "efs-example-service"
  cluster          = aws_ecs_cluster.main.id
  task_definition  = aws_ecs_task_definition.efs-task.arn
  desired_count    = 1
  launch_type      = "FARGATE"
  platform_version = "1.4.0" //not specfying this version explictly will not currently work for mounting EFS to Fargate
  
  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks_efs.id]
    subnets          = [aws_subnet.public.id]
    assign_public_ip = true
  }
 depends_on = [aws_iam_role_policy_attachment.ecs_task_execution_role]
}

resource "aws_ecs_task_definition" "efs-task" {
  family                   = "efs-example-task-fargate" 
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "1024"

  container_definitions = <<DEFINITION
[
  {
      "memory": 128,
      "cpu": 10,
      "portMappings": [
          {
              "hostPort": 80,
              "containerPort": 80,
              "protocol": "tcp"
          }
      ],
      "essential": true,
      "mountPoints": [
          {
              "containerPath": "/usr/share/nginx/html",
              "sourceVolume": "efs-html"
          }
      ],
      "name": "nginx",
      "image": "nginx"
  }
]
DEFINITION

  volume {
    name      = "efs-html"
    efs_volume_configuration {
      file_system_id = aws_efs_file_system.foo.id
      root_directory = "/"
    }
  }
}



