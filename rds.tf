resource "random_password" "global_rds_master" {
  length           = 16
  special          = true
  override_special = "_!%^"
}

resource "aws_secretsmanager_secret" "global_rds_password" {
  name = "master-rds-password"
}

resource "aws_secretsmanager_secret_version" "global_password" {
  secret_id     = aws_secretsmanager_secret.global_rds_password.id
  secret_string = random_password.global_rds_master.result
}

data "aws_secretsmanager_secret" "global_rds_password" {
  name       = "master-rds-password"
  depends_on = [aws_secretsmanager_secret_version.global_password]
}

data "aws_secretsmanager_secret_version" "global_password" {
  secret_id  = data.aws_secretsmanager_secret.global_rds_password.id
  depends_on = [aws_secretsmanager_secret_version.global_password]
}

resource "aws_db_subnet_group" "rds_db_subnet_group" {
  name       = "devsermariadb_subnet_group"
  subnet_ids = [aws_subnet.main_vpc_subnet.0.id, aws_subnet.main_vpc_subnet.1.id, aws_subnet.main_vpc_subnet.2.id, aws_subnet.main_vpc_subnet.3.id]
  tags = {
    Name = "RDS Subnets"
  }
}

resource "aws_db_instance" "rds" {
  engine                 = "mariadb"
  engine_version         = "10.6.8"
  instance_class         = "db.t3.small"
  db_name                = "devsermariadb"
  identifier             = "dev-mariadb"
  username               = "master"
  password               = data.aws_secretsmanager_secret_version.global_password.secret_string
  parameter_group_name   = "default.mariadb10.6"
  db_subnet_group_name   = aws_db_subnet_group.rds_db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.dev-mariadb-sg.id]
  skip_final_snapshot    = true
  allocated_storage      = 50
  max_allocated_storage  = 100
  publicly_accessible    = true
  multi_az               = true
  apply_immediately      = true
}