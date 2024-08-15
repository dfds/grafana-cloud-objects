# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  extra_arguments "prevent_destroy_protection" {
    commands = ["apply", "destroy"]

    arguments = [
      "-var=prevent_destroy=true"
    ]

  source = "${path_relative_from_include()}//."
  }
}

# Include all settings from the root terraform.tfvars file
include {
  path = "${find_in_parent_folders()}"
}

inputs = {
  environment                          = "demo"
  enable_ce_folder                     = true
  enable_dashboards                    = true
  enable_alerts                        = true
  enable_grafana_data_source_aws_athena = true
  enable_grafana_data_source_aws_cloudwatch = true
  enable_grafana_notification          = true
}

