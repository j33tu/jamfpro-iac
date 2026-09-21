variable "policies" {
  description = "Map of policies to manage"
  type        = any
  default     = {}
}

variable "category_ids" {
  description = "Map of category names to IDs"
  type        = map(string)
  default     = {}
}

variable "smart_group_ids" {
  description = "Map of smart group names to IDs"
  type        = map(string)
  default     = {}
}
