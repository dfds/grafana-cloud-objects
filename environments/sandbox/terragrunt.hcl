# Include all settings from the root terraform.tfvars file
include {
  path = "${find_in_parent_folders()}"
}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "./"
}

inputs = {
  environment = "sandbox"
   # Toggle variables
  enable_ce_folder                     = true
  enable_dashboards                    = true
  enable_alerts                        = true
  enable_grafana_data_source_aws_athena = true
  enable_grafana_data_source_aws_cloudwatch = true
  enable_grafana_notification          = true
}



