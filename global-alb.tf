# Devser's Application Load Balancer

resource "aws_lb" "ecs_alb" {
  name                             = var.stack_name
  internal                         = false
  load_balancer_type               = "application"
  security_groups                  = [aws_security_group.elb_sg_group.id]
  subnets                          = aws_subnet.main_vpc_subnet.*.id
  enable_cross_zone_load_balancing = true
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "ecs_alb_listener_80" {
  load_balancer_arn = aws_lb.ecs_alb.arn

  port     = 80
  protocol = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "ecs_alb_listener_443" {
  load_balancer_arn = aws_lb.ecs_alb.arn

  port     = 443
  protocol = "HTTPS"

  ssl_policy      = "ELBSecurityPolicy-2016-08"
  certificate_arn = "arn:aws:acm:us-east-1:879582495412:certificate/a4328c4d-a039-4aab-8b0b-0b9f0fd6a06e"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.global_alb_tg.arn
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_target_group" "global_alb_tg" {
  name        = "devser"
  target_type = "instance"
  port        = 8888
  protocol    = "HTTPS"
  vpc_id      = aws_vpc.main_vpc.id

  load_balancing_algorithm_type = "least_outstanding_requests"

  stickiness {
    enabled = true
    type    = "lb_cookie"
  }

  health_check {
    healthy_threshold   = 2
    interval            = 61
    protocol            = "HTTPS"
    unhealthy_threshold = 2
    path                = "/index.html"
    port                = "traffic-port"
    timeout             = 60
    matcher             = "200-399"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_target_group" "pma_alb_tg" {
  name        = "phpmyadmin"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main_vpc.id

  load_balancing_algorithm_type = "least_outstanding_requests"

  stickiness {
    enabled = true
    type    = "lb_cookie"
  }

  health_check {
    healthy_threshold   = 2
    interval            = 61
    protocol            = "HTTP"
    unhealthy_threshold = 2
    path                = "/index.php"
    port                = "traffic-port"
    timeout             = 60
    matcher             = "200-399"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener_rule" "devser_host_based_routing" {
  listener_arn = aws_lb_listener.ecs_alb_listener_443.arn
  priority     = 2

  action {
    type = "forward"
    forward {

      target_group {
        arn    = aws_lb_target_group.global_alb_tg.arn
        weight = 1
      }

      target_group {
        arn    = aws_lb_target_group.pma_alb_tg.arn
        weight = 99
      }

      stickiness {
        enabled  = true
        duration = 600
      }
    }
  }

  condition {
    host_header {
      values = ["db.devser.net"]
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}


# Shared's Application Load Balancer

resource "aws_lb" "shared_ecs_alb" {
  name                             = var.cluser_name
  internal                         = false
  load_balancer_type               = "application"
  security_groups                  = [aws_security_group.elb_sg_shared_group.id]
  subnets                          = aws_subnet.main_vpc_subnet.*.id
  enable_cross_zone_load_balancing = true
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "ecs_shared_alb_listener_80" {
  load_balancer_arn = aws_lb.shared_ecs_alb.arn

  port     = 80
  protocol = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "ecs_shared_alb_listener_443" {
  load_balancer_arn = aws_lb.shared_ecs_alb.arn

  port     = 443
  protocol = "HTTPS"

  ssl_policy      = "ELBSecurityPolicy-2016-08"
  certificate_arn = "arn:aws:acm:us-east-1:879582495412:certificate/a4328c4d-a039-4aab-8b0b-0b9f0fd6a06e"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.shared_alb_tg.arn
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_target_group" "shared_alb_tg" {
  name        = "shared"
  target_type = "instance"
  port        = 8888
  protocol    = "HTTPS"
  vpc_id      = aws_vpc.main_vpc.id

  load_balancing_algorithm_type = "least_outstanding_requests"

  stickiness {
    enabled = true
    type    = "lb_cookie"
  }

  health_check {
    healthy_threshold   = 2
    interval            = 61
    protocol            = "HTTPS"
    unhealthy_threshold = 2
    path                = "/index.html"
    port                = "traffic-port"
    timeout             = 60
    matcher             = "200-399"
  }

  lifecycle {
    create_before_destroy = true
  }
}