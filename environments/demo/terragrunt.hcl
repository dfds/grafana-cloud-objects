# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "${path_relative_from_include()}//."
}

# Include all settings from the root terraform.tfvars file
include {
  path = "${find_in_parent_folders()}"
}

inputs = {
  environment = "demo"
}
