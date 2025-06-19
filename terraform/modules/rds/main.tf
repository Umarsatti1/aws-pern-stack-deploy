resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "${var.name}-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "${var.name}-subnet-group"
  }
}

resource "aws_db_instance" "db_instance" {
  allocated_storage    = 20
  identifier           = var.name
  db_name              = var.db_name
  engine               = "postgres"
  engine_version       = "17.4"
  instance_class       = "db.t3.micro"
  username             = var.db_username
  password             = var.db_password
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [var.rds_sg_id]
  port                 = var.db_port
  publicly_accessible  = false
  parameter_group_name = "default.postgres17"
  skip_final_snapshot  = true
}