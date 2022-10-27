resource "aws_ecr_repository" "ecr-nginx" {
  name = "nginx-wordpress"
  tags = {
    name = "nginx_wordpress-image"
  }
}
resource "aws_ecr_repository" "ecr-nginx-privacy" {
  name = "nginx-wordpress-privacy"
  tags = {
    name = "nginx_wordpress_privacy"
  }
}
resource "aws_ecr_repository" "ecr-php" {
  name = "php81-wordpress"
  tags = {
    name = "php81_wordpress-image"
  }
}
resource "aws_ecr_repository" "ecr-php-74" {
  name = "php74-wordpress"
  tags = {
    name = "php74_wordpress-image"
  }
}
resource "aws_ecr_repository" "ecr-default" {
  name = "default-service"
  tags = {
    name = "default-service"
  }
}
resource "aws_ecr_repository" "ecr-pma" {
  name = "pma-service"
  tags = {
    name = "PHPMyAdmin"
  }
}