
resource "aws_route53_zone" "hosted_zone" {
  name = var.domain_name
}

resource "aws_route53_record" "www_record" {
  zone_id = aws_route53_zone.hosted_zone.zone_id
  name    = "terraform-test.${var.domain_name}."
  type    = "A"

  alias {
    name                   = aws_alb.new_alb.dns_name
    zone_id                = aws_alb.new_alb.zone_id
    evaluate_target_health = true
  }
}