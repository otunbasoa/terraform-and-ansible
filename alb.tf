resource "aws_alb" "new_alb" {
  name               = "new-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.elb-sg.id]
  #subnets = [aws_subnet.custom_subnet[count.index].id]
  #subnets = [aws_subnet.custom_subnet.id]
  #subnets = aws_subnet.custom_subnet[count.index]
  subnets = aws_subnet.custom_subnet.*.id

}
resource "aws_alb_target_group" "tg" {
  name     = "TargetGroup"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.custom_vpc.id
  health_check {
    enabled             = true
    healthy_threshold   = 3
    interval            = 10
    matcher             = 200
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 3
    unhealthy_threshold = 2
  }
}

resource "aws_alb_listener" "new_listener" {
  load_balancer_arn = aws_alb.new_alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_alb_target_group.tg.arn
    type             = "forward"
  }
}

resource "aws_alb_target_group_attachment" "tg_attachment" {
  count            = length(var.public_subnet_cidrs)
  target_group_arn = aws_alb_target_group.tg.arn
  target_id        = aws_instance.new_instance[count.index].id
  port             = 80
}

output "alb_dns_name" {
  value = aws_alb.new_alb.dns_name
}

output "alb_arn" {
  value = aws_alb.new_alb.arn
}

output "target_group_arn" {
  value = aws_alb_target_group.tg.arn
}

output "target_group_name" {
  value = aws_alb_target_group.tg.name
}
