# Remote state backend.
#
# Local state is never used for this repo: CI runs are stateless, and two
# people (or a human + CI) applying against local state will corrupt it.
#
# Fill in your own bucket/table names, or swap this block for Terraform Cloud
# / Azure Storage / GCS if that's what your org standardizes on.

terraform {
  backend "s3" {
    bucket         = "REPLACE-ME-jamf-gitops-tfstate"
    key            = "jamf-pro/production/terraform.tfstate"
    region         = "REPLACE-ME-aws-region"
    dynamodb_table = "REPLACE-ME-jamf-gitops-tf-locks"
    encrypt        = true
  }
}

# --- Terraform Cloud alternative ---
# terraform {
#   cloud {
#     organization = "REPLACE-ME"
#     workspaces {
#       name = "jamf-gitops-production"
#     }
#   }
# }
