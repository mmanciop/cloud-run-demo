#!/bin/bash

echo 'Enabling Google Cloud Platform APIs:'

apis=( 'appengine.googleapis.com' 'cloudbuild.googleapis.com' 'compute.googleapis.com' 'cloudscheduler.googleapis.com' )

for api in "${apis[@]}"
do
    echo -n "Enabling ${api} ... "
	if ! output=$(CLOUDSDK_CORE_PROJECT="${GOOGLE_CLOUD_PROJECT}" gcloud services enable "${api}"); then
        echo 'Failed:'
        echo "${output}"
        exit 1
    else
        echo 'OK'
    fi
done

echo -n 'Generating Terraform configuration ... '

echo "
instana_agent_key=\"${INSTANA_AGENT_KEY}\"
instana_download_key=\"${INSTANA_AGENT_KEY}\"
instana_serverless_endpoint=\"${INSTANA_ENDPOINT_URL}\"
project_id=\"${GOOGLE_CLOUD_PROJECT}\"
region=\"${GOOGLE_CLOUD_REGION}\"
" > local.auto.tfvars

echo 'OK'

echo -n 'Initializing Terraform ... '

if ! output=$(terraform init); then
    echo 'Failed:'
    echo "${output}"
    exit 1
else
    echo 'OK'
fi

echo -n 'Checking for existence of App Engine application ... '
if ! output=$(terraform import google_app_engine_application.scheduler_application "${GOOGLE_CLOUD_PROJECT}" || true); then
    echo 'Import into Terraform failed:'
    echo "${output}"
    exit 1
else
    echo 'Found'
fi

# echo -n 'Pulling the Instana Cloud Native Buildpack in the local Docker daemon ... '
# if ! output=$(echo "${INSTANA_AGENT_KEY}" | docker login containers.instana.io -u '_' --password-stdin && docker pull containers.instana.io/instana/release/google/buildpack ); then
#     echo 'Failed:'
#     echo "${output}"
#     exit 1
# else
#     echo 'OK'
# fi

echo 'Applying Terraform ... '

terraform apply -auto-approve