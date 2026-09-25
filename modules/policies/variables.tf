variable "policies" {
  type = map(object({
    category_id = string
    frequency   = string
    enabled     = optional(bool, true)

    # Triggers
    trigger_checkin    = optional(bool, false)
    trigger_enrollment = optional(bool, false)
    trigger_login      = optional(bool, false)
    trigger_other      = optional(string, "")

    # Scope
    all_computers = optional(bool, false)

    # Executable scripts
    scripts = optional(list(object({
      id         = string
      priority   = optional(string, "AFTER")
      parameter4 = optional(string, "")
      parameter5 = optional(string, "")
    })), [])
  }))
  description = "Map of Jamf Pro policies"
  default     = {}
}
