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

## Migrating `cloudflare_record` from 4 to 5

Get the records with something like:
```
terraform state list | grep 'cloudflare_record\.' | xargs -n1 terraform state show >cloudflare_record.out
```

Build a file of `removed` blocks:
```
awk -F'[ :]' '/^# cloudflare_record\./ { printf("removed {\n  from = %s\n  lifecycle {\n    destroy = false\n  }\n}\n", $2) }' cloudflare_record.out >removed.tf
```

Comment the resources and apply to clean them from state. Remove the removed.tf (or whatever) and generate the imports:

```
awk -F'[ :"]*' '/^# cloudflare_record\./ { printf("import {\n  to = %s\n", $2) } /^ *id *= / { RECID=$4 } /^ *zone_id *= / { ZONEID=$4 } /^}/ { printf("  id = \"%s/%s\"\n}\n", ZONEID, RECID) }' cloudflare_record.out |sed -e 's/cloudflare_record/cloudflare_dns_record/' >import.tf
```
