resource "aws_lb" "internal" {
  name = "${var.name}-alb"
  internal = true
  load_balancer_type = "application"
  subnets = var.private_subnet_ids
  security_groups = [aws_security_group.alb_sg.id]
}


resource "aws_lb_target_group" "alb_tg" {
  name = "${var.name}-tg"
  port = 18789
  protocol = "HTTP"
  vpc_id = var.vpc_id
  health_check {
    path = "/health"
    interval = 30
    timeout = 5
    healthy_threshold = 2
    unhealthy_threshold = 3
  }
}
