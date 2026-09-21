# Smart groups drive nearly all scoping in Jamf Pro (which Macs get which
# policy, printer, profile). Keep the criteria logic here so it's reviewed
# in PRs like anything else, instead of being clicked together in the console.

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
