To get your Jamf Pro GitOps IaC workflow operational from absolute scratch, here is the step-by-step checklist of everything you need to create across Jamf Pro, GitHub, and AWS/Azure Storage.1.Create OAuth 2.0 API Role & Client in Jamf Pro:Prerequisite - 5 min.Log into your Jamf Pro portal ([https://yourcompany.jamfcloud.com](https://yourcompany.jamfcloud.com)).Go to Settings > System > API Roles and Clients.Click API Roles > + New:Name: Terraform-Automation-RolePrivileges: Grant Create, Read, Update, and Delete for Categories, Scripts, Extension Attributes, Computer Extension Attributes, Smart Computer Groups, Static Computer Groups, and macOS Configuration Profiles.Click API Clients > + New:Name: Terraform-Automation-ClientAssign Role: Terraform-Automation-RoleClick Generate Secret and immediately copy the Client ID and Client Secret.2.Provision Remote State Storage & Locking:AWS S3 / Azure Blob - 5 min.Create a secure remote storage bucket so Terraform state isn't stored locally on personal computers.Example (AWS S3 + DynamoDB via AWS CLI):Bash# Create S3 Bucket for state
aws s3api create-bucket --bucket company-jamf-tfstate --region us-east-1

# Enable Bucket Versioning
aws s3api put-bucket-versioning --bucket company-jamf-tfstate --versioning-configuration Status=Enabled

# Create DynamoDB table for State Locking
aws dynamodb create-table \
  --table-name jamf-tfstate-locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST
3.Create the Git Repository Structure:GitHub - 10 min.Initialize a new Git repository locally (jamf-gitops) and create the file layout recommended by Jamf:Plaintextjamf-gitops/
├── .github/
│   └── workflows/
│       ├── terraform-plan.yml
│       └── terraform-apply.yml
├── modules/
│   ├── categories/
│   │   ├── main.tf
│   │   └── variables.tf
│   └── smart_groups/
│       ├── main.tf
│       └── variables.tf
├── scripts/
│   └── extension_attributes/
│       └── check_os_version.sh
├── backend.tf
├── main.tf
├── provider.tf
└── variables.tf
4.Write the Core Terraform Configurations:Terraform Code - 10 min.Create the primary configuration files in your repository root directory:provider.tfTerraformterraform {
  required_version = ">= 1.5.0"
  required_providers {
    jamfpro = {
      source  = "deploymenttheory/jamfpro"
      version = "~> 0.18.0"
    }
  }
}

provider "jamfpro" {
  jamfpro_instance_fqdn = var.jamfpro_instance_fqdn
  auth_method           = "oauth2"
  client_id             = var.jamfpro_client_id
  client_secret         = var.jamfpro_client_secret
}
backend.tfTerraformterraform {
  backend "s3" {
    bucket         = "company-jamf-tfstate"
    key            = "prod/jamfpro.tfstate"
    region         = "us-east-1"
    dynamodb_table = "jamf-tfstate-locks"
    encrypt        = true
  }
}
variables.tfTerraformvariable "jamfpro_instance_fqdn" {
  type        = string
  description = "Jamf Pro FQDN (e.g. https://tenant.jamfcloud.com)"
}

variable "jamfpro_client_id" {
  type        = string
  sensitive   = true
}

variable "jamfpro_client_secret" {
  type        = string
  sensitive   = true
}
main.tfTerraform# Test Resource: Create a baseline category
resource "jamfpro_category" "security" {
  name     = "Security & Compliance"
  priority = 10
}
5.Configure GitHub Secrets & CI/CD Pipelines:GitHub Actions - 10 min.In GitHub, go to Settings > Secrets and variables > Actions > New repository secret.Add the following secrets:JAMFPRO_INSTANCE_FQDNJAMFPRO_CLIENT_IDJAMFPRO_CLIENT_SECRETAWS_ACCESS_KEY_IDAWS_SECRET_ACCESS_KEYCreate .github/workflows/terraform-plan.yml (Runs terraform plan on Pull Requests):YAMLname: "Jamf Pro Terraform Plan"

on:
  pull_request:
    branches: [ main ]
    paths: [ '**.tf', 'scripts/**' ]

jobs:
  plan:
    runs-on: ubuntu-latest
    env:
      TF_VAR_jamfpro_instance_fqdn: ${{ secrets.JAMFPRO_INSTANCE_FQDN }}
      TF_VAR_jamfpro_client_id: ${{ secrets.JAMFPRO_CLIENT_ID }}
      TF_VAR_jamfpro_client_secret: ${{ secrets.JAMFPRO_CLIENT_SECRET }}
      AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
      AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}

    steps:
      - uses: actions/checkout@v4
      - uses: hashicorp/setup-terraform@v3
        with:
          terraform_version: "1.7.0"

      - name: Check Formatting
        run: terraform fmt -check -recursive

      - name: Terraform Init
        run: terraform init

      - name: Terraform Validate
        run: terraform validate

      - name: Terraform Plan
        run: terraform plan -no-color
Create .github/workflows/terraform-apply.yml (Executes updates when PR is merged):YAMLname: "Jamf Pro Terraform Apply"

on:
  push:
    branches: [ main ]
    paths: [ '**.tf', 'scripts/**' ]

jobs:
  apply:
    runs-on: ubuntu-latest
    env:
      TF_VAR_jamfpro_instance_fqdn: ${{ secrets.JAMFPRO_INSTANCE_FQDN }}
      TF_VAR_jamfpro_client_id: ${{ secrets.JAMFPRO_CLIENT_ID }}
      TF_VAR_jamfpro_client_secret: ${{ secrets.JAMFPRO_CLIENT_SECRET }}
      AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
      AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}

    steps:
      - uses: actions/checkout@v4
      - uses: hashicorp/setup-terraform@v3
        with:
          terraform_version: "1.7.0"

      - name: Terraform Init
        run: terraform init

      - name: Terraform Apply
        run: terraform apply -auto-approve -parallelism=1
6.Test the Workflow:Verification - 5 min.Create a new git branch: git checkout -b feature/add-smart-groups.Add a resource into main.tf:Terraformresource "jamfpro_smart_computer_group" "outdated_macs" {
  name        = "macOS Outdated (< 14.0)"
  category_id = jamfpro_category.security.id

  criteria {
    name        = "Operating System Version"
    priority    = 0
    and_or      = "and"
    search_type = "less than"
    value       = "14.0.0"
  }
}
Push the branch to GitHub and open a Pull Request.Confirm that the Jamf Pro Terraform Plan workflow passes and shows the new group in the plan preview.Merge the Pull Request and verify that the new Smart Group appears instantly inside Jamf Pro.How to Verify SuccessAfter merging your pull request, log into your Jamf Pro admin GUI (Settings > Categories or Computers > Smart Computer Groups). You should see the newly generated "Security & Compliance" category and "macOS Outdated (< 14.0)" group created automatically without manual UI input.