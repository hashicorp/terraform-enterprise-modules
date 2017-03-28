variable "hostname" {}

variable "zone_id" {}

variable "alias_dns_name" {}
variable "alias_zone_id" {}

resource "aws_route53_record" "rec" {
  count   = "${var.zone_id != "" ? 1 : 0}"
  zone_id = "${var.zone_id}"
  name    = "${var.hostname}"
  type    = "A"

  alias {
    name                   = "${var.alias_dns_name}"
    zone_id                = "${var.alias_zone_id}"
    evaluate_target_health = false
  }
}
