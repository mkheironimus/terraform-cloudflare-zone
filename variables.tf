variable "zone" {
  description = "Zone name (domain)"
}

variable "plan" {
  description = "Cloudflare plan"
  default = "free"
}

variable "zone_type" {
  description = "Cloudflare DNS zone type"
  default = "full"
}

variable "email_obfuscation" {
  description = "Cloudflare email address obfuscation"
  default = "on"
}

variable "ssl_type" {
  description = "Cloudflare SSL type (you probably want flexible or full)"
  default = "flexible"
}

variable "cache" {
  description = "Force default cache rule (do you want cache_everything?)"
  default = ""
}

variable "dnssec" {
  description = "Enable dnssec on the zone"
  default = true
}
