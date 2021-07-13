# security.tf

# Traffic to the ECS cluster should follow this SG
resource "aws_security_group" "ecs_tasks_efs" {
  name        = "myapp-ecs-tasks-security-group"
  description = "allow inbound 22, 80, 2049, 5432 access"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol        = "tcp"
    from_port       = 22
    to_port         = 22
    cidr_blocks = ["0.0.0.0/0"]
  } 

 ingress {
    protocol        = "tcp"
    from_port       = 80
    to_port         = 80
    cidr_blocks = ["0.0.0.0/0"]
  } 

 ingress {
    protocol        = "tcp"
    from_port       = 2049
    to_port         = 2049
    cidr_blocks = [aws_vpc.main.cidr_block]
  } 

  ingress {
    protocol        = "tcp"
    from_port       = 5432
    to_port         = 5432
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
} 


