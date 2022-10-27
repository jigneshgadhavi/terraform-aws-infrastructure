terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.20.2"
    }
    mysql = {
      source  = "petoju/mysql"
      version = "3.0.19"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}
provider "aws" {
  region = "us-east-1"
}
provider "mysql" {
  endpoint = aws_db_instance.rds.endpoint
  username = "master"
  password = data.aws_secretsmanager_secret_version.global_password.secret_string
}