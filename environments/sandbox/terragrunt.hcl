# Include all settings from the root terraform.tfvars file
include {
  path = "${find_in_parent_folders()}"
}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "./"
  backend "s3" {
    bucket         = "dfds-terraform-state"
    key            = "grafana-cloud-objects/${path_relative_to_include()}/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "dfds-terraform-state-lock"
  }
}

inputs = {
  environment = "sandbox"
}
