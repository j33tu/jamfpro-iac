# jamf-gitops

Jamf Pro managed as code via Terraform, with plan/apply run through GitHub
Actions.

## Structure

```
jamf-gitops/
├── .github/workflows/       # CI/CD: plan on PR, apply on merge to main
├── modules/
│   ├── categories/          # Jamf Pro categories (foundation for others)
│   ├── smart_groups/        # Smart group definitions + criteria
│   └── printers/            # Printer objects + PPDs + deploy policies
├── scripts/extension_attributes/
├── environments/production/ # Room to add staging/production var files later
├── backend.tf                # Remote state config (S3 + DynamoDB by default)
├── provider.tf                # Jamf Pro provider (OAuth2, no hardcoded secrets)
├── main.tf                    # Wires modules together
├── variables.tf
└── versions.tf
```

## First-time setup

1. **Create a dedicated Jamf Pro API role + client** scoped only to what
   Terraform needs to manage (not a full admin account). Settings > System
   > API Roles and Clients in Jamf Pro.
2. **Create remote state storage** (S3 bucket + DynamoDB table, or swap
   `backend.tf` for Terraform Cloud/Azure/GCS) and fill in the real
   names in `backend.tf`.
3. **Copy `terraform.tfvars.example` to `terraform.tfvars`** and fill in
   your real values for local use. This file is gitignored -- never commit
   real credentials.
4. **Add the same credentials as GitHub Actions secrets** in this repo's
   Settings > Secrets and variables > Actions:
   - `JAMFPRO_INSTANCE_FQDN`
   - `JAMFPRO_CLIENT_ID`
   - `JAMFPRO_CLIENT_SECRET`
5. (Recommended) In Settings > Environments, create a `production`
   environment with a required reviewer, so `terraform-apply.yml` pauses
   for manual approval before touching your live Jamf Pro instance.

## Day-to-day workflow

1. Branch, edit the relevant `.tf` file (e.g. add a printer in
   `modules/printers/variables.tf`).
2. Open a PR. `terraform-plan.yml` runs automatically and posts the diff
   as a PR comment.
3. A human reviews the plan output -- this is your safety net before
   anything touches production.
4. Merge to `main`. `terraform-apply.yml` runs and applies the change.

## Adding a new printer

1. If it needs a manufacturer PPD (not the generic driver), drop the
   `.ppd` file in `modules/printers/ppds/`.
2. Add an entry to the `printers` map in `modules/printers/variables.tf`.
3. Make sure `scope_group_name` matches an existing key in
   `modules/smart_groups/variables.tf` (add one there first if needed).
4. Open a PR as above.

## Local development

```bash
terraform init
terraform fmt -recursive
terraform validate
terraform plan
```

Never run `terraform apply` locally against production -- let CI do it,
so every change has an audit trail and a reviewed plan.
