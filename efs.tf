resource "aws_efs_file_system" "foo" {
  tags = {
    Name = "ECS-EFS-FS"
  }
}

resource "aws_efs_mount_target" "mount" {
  file_system_id = aws_efs_file_system.foo.id
  subnet_id      = aws_subnet.public.id 
  security_groups = [aws_security_group.ecs_tasks_efs.id]
  
}
