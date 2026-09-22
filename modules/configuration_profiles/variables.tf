variable "profiles" {
  type = map(object({
    description        = string
    category_id        = string
    level              = string
    all_computers      = bool
    payload_path       = string
    redeploy_on_update = optional(bool, false)
  }))
  description = "Map of Configuration Profiles"
  default     = {}
}
