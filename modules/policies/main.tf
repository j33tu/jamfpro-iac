resource "jamfpro_policy" "this" {
  for_each = var.policies

  name            = each.key
  enabled         = each.value.enabled
  category_id     = each.value.category_id
  frequency       = each.value.frequency
  trigger_checkin = each.value.trigger_checkin
  trigger_other   = each.value.trigger_other
  target_drive    = "/"

  scope {
    all_computers      = false
    computer_group_ids = each.value.computer_group_ids
  }

  payloads {
    # Dynamically inject script payload if script_id is defined
    dynamic "scripts" {
      for_each = each.value.script_id != null ? [1] : []
      content {
        id       = each.value.script_id
        priority = each.value.script_priority
      }
    }

    # Dynamically inject package payload if package_id is defined
    dynamic "packages" {
      for_each = each.value.package_id != null ? [1] : []
      content {
        distribution_point = "default"
        package {
          id     = each.value.package_id
          action = each.value.package_action
        }
      }
    }
  }
}
