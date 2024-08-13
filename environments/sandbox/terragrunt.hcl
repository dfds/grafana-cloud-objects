# Include all settings from the root terraform.tfvars file
include {
  path = "${path_relative_from_include()}//."
}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "./"
}

inputs = {
  environment = "sandbox"
  folder_title = "Cloud Engineering"
}
