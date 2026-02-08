resource "aws_security_group" "alb_sg" {
  name = "${var.name}-alb-sg"
  description = "ALB security group for internal ALB"
  vpc_id = var.vpc_id

  ingress { 
    from_port = 80, 
    to_port = 80, 
    protocol = "tcp", 
    cidr_blocks = ["0.0.0.0/0"] 
  }
  ingress { 
    from_port = 443, 
    to_port = 443, 
    protocol = "tcp", 
    cidr_blocks = ["0.0.0.0/0"] 
  }
  egress { 
    from_port = 0, 
    to_port = 0, 
    protocol = "-1", 
    cidr_blocks = ["0.0.0.0/0"] 
  }
}


resource "aws_security_group" "ecs_sg" {
  name = "${var.name}-ecs-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port = 18789
    to_port = 18789
    protocol = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
    }
  egress { 
    from_port = 0, 
    to_port = 0, 
    protocol = "-1", 
    cidr_blocks = ["0.0.0.0/0"] 
  }
}
