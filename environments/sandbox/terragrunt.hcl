# Include all settings from the root terraform.tfvars file
include {
  path = "${find_in_parent_folders()}"
}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "./"
}

dependency "variables" {
  config_path = "../../variables.tf"
}

inputs = {
  environment = "sandbox"
  folder_title = dependency.variables.outputs.folder_title
}
