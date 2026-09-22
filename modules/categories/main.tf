resource "jamfpro_category" "this" {
  for_each = var.categories

  name     = each.key
  priority = each.value.priority
}
