# 1. Categories
module "categories" {
  source = "./modules/categories"

  categories = {
    "Security & Compliance" = { priority = 10 }
    "Patch Management"      = { priority = 20 }
  }
}

# 2. Buildings
module "buildings" {
  source = "./modules/buildings"

  building_names = var.building_names
}

# 3. Scripts
module "scripts" {
  source = "./modules/scripts"

  scripts = {
    for name, cfg in var.scripts_config : name => {
      category_id = module.categories.category_ids[cfg.category_name]
      info        = cfg.info
      notes       = cfg.notes
      priority    = cfg.priority
      file_path   = cfg.file_path
    }
  }
}

# 4. Smart Computer Groups
module "smart_groups" {
  source = "./modules/smart_groups"

  smart_groups = {
    "macOS Sequoia Endpoints" = {
      criteria = [
        {
          name        = "Operating System Version"
          priority    = 0
          and_or      = "and"
          search_type = "is"
          value       = "15.0.0"
        }
      ]
    }
  }
}
module "configuration_profiles" {
  source = "./modules/configuration_profiles"

  profiles = {
    "macOS Passcode Policy" = {
      description        = "Enforces strict passcode requirements for corporate endpoints."
      category_id        = module.categories.category_ids["Security & Compliance"]
      level              = "computer"
      all_computers      = true
      redeploy_on_update = false
      payload_path       = "${path.module}/payloads/passcode_policy.mobileconfig"
    }
  }
}
