terraform {
  required_version = ">= 0.12.0"
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "~> 2.0"
    }
  }
}

resource "cloudflare_zone" "zone" {
  zone = var.zone
  plan = var.plan != "free" ? var.plan : null
  type = var.zone_type
}

resource "cloudflare_zone_settings_override" "settings" {
  zone_id = cloudflare_zone.zone.id
  settings {
    brotli            = "on"
    ipv6              = "on"
    always_use_https  = "on"
    ssl               = var.ssl_type
    tls_client_auth   = "off"
    websockets        = "on"
    email_obfuscation = var.email_obfuscation
    minify {
      css  = "on"
      html = "on"
      js   = "on"
    }
  }
}

resource "cloudflare_page_rule" "cache_all" {
  count    = var.cache != "" ? 1 : 0
  zone_id  = cloudflare_zone.zone.id
  target   = "${var.zone}/*"
  priority = 1
  actions {
    cache_level = var.cache
  }
}

resource "cloudflare_zone_dnssec" "zone" {
  count   = var.dnssec ? 1 : 0
  zone_id = cloudflare_zone.zone.id
}
