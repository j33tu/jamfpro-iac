variable "smart_groups" {
  type = map(object({
    criteria = list(object({
      name        = string
      priority    = number
      and_or      = string
      search_type = string
      value       = string
    }))
  }))
  description = "Map of Smart Computer Groups and their criteria"
  default     = {}
}
