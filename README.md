# Grafana Cloud Objects

This repo contains the environment specific terraform code and resources that can be deployed to a Grafana Cloud stack.

## Running manually

The authentication details for your Grafana Cloud stack needs to be passed in to the Docker container. This includes the URL to the stack and the API token for a service account for that stack.

You also need to provide the security credentials for the AWS account where to store the Terraform state and locks.

```bash
mkdir ~/git
cd ~/git
git clone git@github.com:dfds/grafana-cloud-objects.git

docker run -it --rm -v ~/git:/code \
--env AWS_ACCESS_KEY_ID=<REDACTED> \
--env AWS_SECRET_ACCESS_KEY=<REDACTED> \
--env TF_VAR_grafana_auth=<REDACTED_SERVICE_ACCOUNT_TOKEN> \
--env TF_VAR_grafana_url=https://<REDACTED_CNAME>/ \
--workdir "/code/grafana-cloud-objects" \
--name grafana-cloud-objects \
--entrypoint "/bin/bash" \
dfdsdk/prime-pipeline:0.6.37
```

When inside the running container:

```bash
cd environments/<ENV>
terragrunt init -upgrade
terragrunt apply
```
