# terraform-cloudflare-zone

Playing with using Terraform to standardize my Cloudflare free plan zone
configurations.

## Permissions

Grant the API token access to edit:

* Zone / Zone
* Zone / Zone Settings
* Zone / Page Rules

I haven't made time to dig in, but if you're missing some access Terraform can
fail at an inconvenient point and break your tfstate. I think the root of the
problem I saw is that the `cloudflare_zone_settings_override` resource is a
little weird in handling options that are and aren't supported in different
plan levels and restoring settings on delete.

## Example usage

```HCL
module "example_zone" {
  source     = "../modules/terraform-cloudflare-zone"
  zone       = "example.com"
  account_id = "123"
  ssl_type   = "full"
}

resource "cloudflare_record" "www_site" {
  zone_id = module.example_zone.id
  name    = "www"
  ...
}
```

## Importing existing zones

Existing zones can be imported using the zone ID.

```
terraform import module.example_zone.cloudflare_zone.zone 1234567890abcdef1234567890abcdef
```

The Cloudflare provider does not currently (as of version 2) support importing
the `cloudflare_zone_settings_override` resource, so make sure it's right and
apply it.
