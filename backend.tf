terraform {
  backend "s3" {
    bucket         = "company-jamf-tfstate"
    key            = "prod/jamfpro.tfstate"
    region         = "us-east-1"
    dynamodb_table = "jamf-tfstate-locks"
    encrypt        = true
  }
}
