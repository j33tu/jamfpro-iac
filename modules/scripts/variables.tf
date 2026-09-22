variable "scripts" {
  type = map(object({
    category_id = string
    info        = string
    notes       = string
    priority    = string
    file_path   = string
  }))
  description = "Map of scripts to deploy"
  default     = {}
}
