resource "aws_route53_zone" "primary" {
  name = "devser.net"
}

resource "aws_route53_record" "mail-devser" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "mail.devser.net"
  type    = "A"
  ttl     = 300
  records = ["173.236.95.66"]
}

resource "aws_route53_record" "mx-devser" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "devser.net"
  type    = "MX"
  ttl     = 300
  records = ["0 mail.devser.net"]
}

resource "aws_route53_record" "spf-devser" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "devser.net"
  type    = "TXT"
  ttl     = 300
  records = ["v=spf1 +a +mx +ip4:173.236.95.66 ~all"]
}

resource "aws_route53_record" "_dmarc-devser" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "_dmarc.devser.net"
  type    = "TXT"
  ttl     = 300
  records = ["v=DMARC1; p=quarantine; rua=mailto: serverdevopps@gmail.com;"]
}

locals {
  dkim_record = "v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAyEDgcXtKdC5/13z1ipSB4WAf26Lpwf44xM9rlxne07lJ13fU+D9Tuu0/zGYFsQQojcChF6DfWaGWIvTofCDw8HR3fcVChn23Z3GPc5WDfjhc5G8p0CUwl2qMAUzpET81ngDClemtokJ4FppAcl/DT5jPaDrQDvrHUx31MFIT5IbZKJPDIWQdKYi6ojH7aHXvjxFsBz0w3LeSS9Tma+DUEltSUHA/4ssayP6oh9CJZaeIB3V+U5euagpQMIq3lpE8hdGc/i387yI0LfiIs1NKrE9RJQexnSce6g63qpovSTGyidqkV6RvVGT5mqUk9Ahqwgl2fHcyyE1d0xd9lOs/swIDAQAB;"
  zone_id = "aws_route53_zone.primary.zone_id"
  domain = "default._domainkey.devser.net"
}

resource "aws_route53_record" "dkim-devser" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "default._domainkey.devser.net"
  type    = "TXT"
  ttl     = 300
  records = [
    join("\"\"", [
      substr(local.dkim_record, 0, 255),
      substr(local.dkim_record, 255, 255),
    ])
  ]
}

resource "aws_route53_record" "mockups-devser" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "mockups.devser.net"
  type    = "A"
  ttl     = 300
  records = ["173.236.95.66"]
}

resource "aws_route53_record" "phpmyadmin-devser" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "db.devser.net"
  type    = "A"
  alias {
    name                   = aws_lb.ecs_alb.dns_name
    zone_id                = aws_lb.ecs_alb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "legacy-devser" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "*.devser.net"
  type    = "A"
  ttl     = 300
  records = ["3.234.57.68"]
}