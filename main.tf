terraform {
  required_version = ">= 1.14.0"
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">= 5.0"
    }
  }
}

resource "cloudflare_zone" "zone" {
  name    = var.zone
  account = { id = var.account_id }
  type    = var.zone_type
}

resource "cloudflare_zone_setting" "always_use_https" {
  zone_id    = cloudflare_zone.zone.id
  setting_id = "always_use_https"
  value      = "on"
}

resource "cloudflare_zone_setting" "brotli" {
  zone_id    = cloudflare_zone.zone.id
  setting_id = "brotli"
  value      = "on"
}

resource "cloudflare_zone_setting" "email_obfuscation" {
  zone_id    = cloudflare_zone.zone.id
  setting_id = "email_obfuscation"
  value      = "on"
}

resource "cloudflare_zone_setting" "ssl" {
  zone_id    = cloudflare_zone.zone.id
  setting_id = "ssl"
  value      = var.ssl_type
}

resource "cloudflare_zone_setting" "websockets" {
  zone_id    = cloudflare_zone.zone.id
  setting_id = "websockets"
  value      = "on"
}

resource "cloudflare_page_rule" "cache_all" {
  count    = var.cache != "" ? 1 : 0
  zone_id  = cloudflare_zone.zone.id
  target   = "${var.zone}/*"
  priority = 1
  actions = {
    cache_level = var.cache
  }
}

resource "cloudflare_zone_dnssec" "zone" {
  count   = var.dnssec ? 1 : 0
  zone_id = cloudflare_zone.zone.id
  status  = "active"
}
