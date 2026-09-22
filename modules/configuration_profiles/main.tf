resource "jamfpro_macos_configuration_profile_plist" "this" {
  for_each = var.profiles

  name               = each.key
  description        = each.value.description
  category_id        = each.value.category_id
  level              = each.value.level
  redeploy_on_update = each.value.redeploy_on_update

  scope {
    all_computers = each.value.all_computers
  }

  payloads = file(each.value.payload_path)
}
