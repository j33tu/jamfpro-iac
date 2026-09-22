resource "jamfpro_smart_computer_group_v2" "this" {
  for_each = var.smart_groups

  name = each.key

  dynamic "criteria" {
    for_each = each.value.criteria
    content {
      name        = criteria.value.name
      priority    = criteria.value.priority
      and_or      = criteria.value.and_or
      search_type = criteria.value.search_type
      value       = criteria.value.value
    }
  }
}
