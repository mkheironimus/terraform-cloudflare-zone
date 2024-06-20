variable "account_id" {
  description = "CloudFlare account ID"
  type        = string
  default     = null
}

variable "cache" {
  description = "Force default cache rule (do you want cache_everything?)"
  type        = string
  default     = ""
}

variable "dnssec" {
  description = "Enable dnssec on the zone"
  type        = bool
  default     = true
}

variable "email_obfuscation" {
  description = "Cloudflare email address obfuscation"
  type        = string
  default     = "on"
}

variable "plan" {
  description = "Cloudflare plan"
  type        = string
  default     = "free"
}

variable "ssl_type" {
  description = "Cloudflare SSL type (you probably want flexible or full)"
  type        = string
  default     = "flexible"
}

variable "zone" {
  description = "Zone name (domain)"
  type        = string
}

variable "zone_type" {
  description = "Cloudflare DNS zone type"
  type        = string
  default     = "full"
}
