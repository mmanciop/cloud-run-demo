# Cloud Run Composite Example

## Prerequisites

* gcloud utility, authorized for the project you want to use

## Build

```bash
terraform init

terraform apply \
    -var 'project=$myproject' \
    -var 'agent_key=$myagent_key' \
    -var 'serverless_endpoint=$myserverless_endpoint'
```
