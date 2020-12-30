#!/bin/bash

set -euo pipefail

echo -n 'Generating Terraform configuration ... '

echo "
instana_agent_key=\"${INSTANA_AGENT_KEY}\"
instana_download_key=\"${INSTANA_AGENT_KEY}\"
instana_serverless_endpoint=\"${INSTANA_ENDPOINT_URL}\"
project_id=\"${GOOGLE_CLOUD_PROJECT}\"
region=\"${GOOGLE_CLOUD_REGION}\"
" > local.auto.tfvars

echo 'OK'