#Synthetic Monitoring

Synthetic Monitoring checks are environment specific, and they are expressed in JSON.
Hence you will need to create a JSON file for each check, and place it in the appropriate
environment folder under the synthetics folder in https://github.com/dfds/grafana-cloud-objects/

The JSON file should have the following structure:

```json
{
    "job": "DFDS",
    "target": "https://www.dfds.com/en",
    "enabled": true,
    "frequency": 60000,
    "timeout": 3000,
    "labels": {
        "env": "prod",
        "availability": "high"
    },
    "settings": {
        "method": "GET",
        "basic_auth": "auth_name",
        "bearer_token": "token_name",
        "valid_status_codes": [
            200
        ],
        "no_follow_redirects": false
    }
}
```

Only 'job' and 'target' are mandatory fields. The rest are optional, and will get assigned default values where applicable.

| Option                       | Default | Valid values                                                             |
| ---------------------------- | ------- | ------------------------------------------------------------------------ |
| enabled                      | true    | true or false                                                            |
| frequency                    | 60000   | Between 1000 and 120000 ms                                               |
| timeout                      | 3000    | Between 1000 and 10000 ms                                                |
| labels                       | {}      | Any map of string values with no special characters except underscores   |
| settings.method              | GET     | GET, CONNECT, DELETE, HEAD, OPTIONS, POST, PUT or TRACE                  |
| settings.basic_auth          | null    | Any string value. Don't story any real username/password in this option. |
| settings.bearer_token        | null    | Any string value. Don't story any real token value in this option.       |
| settings.valid_status_codes  | [200]   | https://www.rfc-editor.org/rfc/rfc9110.html#name-status-codes            |
| settings.no_follow_redirects | false   | true or false                                                            |

## Checks that require authentication

If your check requires basic authentication, you can use the settings.basic_auth option.
You must never store any username or password here. Instead you should write a name that can be used lookup a
username/password combinations from a map.

Example:

```json
"settings": {
    "basic_auth": "check1"
}
```

In your pipeline you can then from a secret manager supply a map of username/password combinations to an environment variable:

```bash
TF_VAR_synthetic_basic_auth='{ "check1" : { "username" : "user1", "password" : "password1" }, "check2" : { "username" : "user2", "password" : "password" } }'
```

If your check requires basic authentication, you can use the settings.bearer_token option.
You must never store any username or password here. Instead you should write a name that can be used lookup a
username/password combinations from a map.

Example:

```json
"settings": {
    "bearer_token": "check1"
}
```

In your pipeline you can then from a secret manager supply a map of username/password combinations to an environment variable:

```bash
TF_VAR_synthetic_bearer_token='{"check1": "bearer_token_1", "check2": "bearer_token_2"}'
```

## Probing from different locations

By default your checks will be probed from Frankfurt and London.

If you prefer probing from other locations, you can override the default probes with by using the synthetic_probes variable
in environments/<environment>/terragrunt.hcl

Example:

```hcl
inputs = {
  environment = "sandbox"
  synthetic_probes = ["Paris", "London", "Mumbai"]
}
```

You can find all the valid values for the synthetic_probes variable in varibles.tf
