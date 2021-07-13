resource "aws_db_subnet_group" "db-subnet-group" {
  name = "main"
  subnet_ids = [aws_subnet.public_subnet_db_1.id, aws_subnet.public_subnet_db_2.id]

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "default" { 
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "11.5"
  instance_class       = "db.t2.micro"
  name                 = "testdb"
  username             = "root"
  password             = "root1234"
  parameter_group_name = "default.postgres11" 
  skip_final_snapshot = true 
  db_subnet_group_name = aws_db_subnet_group.db-subnet-group.name
  vpc_security_group_ids = [aws_security_group.ecs_tasks_efs.id] 
  publicly_accessible = true
  }