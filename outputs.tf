output "id" {
  description = "Cloudflare zone ID"
  value = cloudflare_zone.zone.id
}

output "nameservers" {
  description = "Cloudflare assigned nameservers"
  value = cloudflare_zone.zone.name_servers
}
