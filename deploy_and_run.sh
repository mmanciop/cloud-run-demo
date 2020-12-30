#!/bin/bash

set -euo pipefail

# Ensure we run inside the same directory as the script
cd "$(dirname "$(realpath "$0")")";

echo 'Installing "dialog" as a dependency. No worries, it will go away with this session of Cloud Shell.'

mkdir -p ~/.cloudshell
touch ~/.cloudshell/no-apt-get-warning

sudo apt-get install -y dialog > /dev/null

apis=( 'cloudbuild.googleapis.com' 'compute.googleapis.com' 'storage-api.googleapis.com' 'run.googleapis.com' )

echo 'Enabling the required Google Cloud APIs:'

for api in "${apis[@]}"
do
    echo -n "* ${api} ... "
	if ! output=$(CLOUDSDK_CORE_PROJECT="${GOOGLE_CLOUD_PROJECT}" gcloud services enable "${api}"); then
        echo 'Failed:'
        echo "${output}"
        exit 1
    else
        echo 'OK'
    fi
done

dialog --keep-window --backtitle 'Instana Cloud Run Demo' --ok-label " Got Instana ready, let's go! " --title ' Welcome! ' --msgbox 'You are running the setup for the Instana Cloud Run demo. Keep at hand your Instana dashboard.\n\nIf you do not have an Instana dashboard, go grab one at:\n\nhttps://www.instana.com/trial' 10 60

i=0
W=()
GOOGLE_CLOUD_PROJECTS=()
while read -r project; do
    i=$((i+1))

    project_id=$(echo "${project}" | awk '{ print $1 }' )
    project_name=$(echo "${project}" | awk '{ print $2 }' )

    GOOGLE_CLOUD_PROJECTS+=("${project_id}")

    W+=("${i}" "${project_name}")
done < <( gcloud projects list | tail -n +2 )

i=$(dialog --keep-window --clear --backtitle 'Instana Cloud Run Demo' --title ' Google Cloud Project ' --menu 'Choose which Project to deploy the demo into:' 24 80 17 "${W[@]}" 3>&2 2>&1 1>&3)
GOOGLE_CLOUD_PROJECT=${GOOGLE_CLOUD_PROJECTS[$((i-1))]}

if [ ! $? -eq 0 ]; then
    exit 0;
fi

i=0
W=()
GOOGLE_CLOUD_REGIONS=()
while read -r region; do
    i=$((i+1))
    GOOGLE_CLOUD_REGIONS+=("${region}")
    W+=("${i}" "${region}")
done < <( gcloud run regions list --platform=managed | tail -n +2 )

i=$(dialog --keep-window --clear --backtitle 'Instana Cloud Run Demo' --title ' Google Cloud Region' --menu 'Choose which Region to deploy the demo into:' 24 80 17 "${W[@]}" 3>&2 2>&1 1>&3)
GOOGLE_CLOUD_REGION=${GOOGLE_CLOUD_REGIONS[$((i-1))]}

if ! INSTANA_ENDPOINT_URL=$(dialog --keep-window --clear --backtitle 'Instana Cloud Run Demo' --title ' Instana Endpoint URL ' --inputbox 'Enter the Instana Endpoint URL of your Instana Dashboard:' 8 80  3>&2 2>&1 1>&3); then
    exit 0;
fi

if ! INSTANA_AGENT_KEY=$(dialog --keep-window --clear --backtitle 'Instana Cloud Run Demo' --title ' Instana Agent Key ' --inputbox 'Enter the Instana Agent Key of your Instana Dashboard:' 8 80  3>&2 2>&1 1>&3); then
    exit 0;
fi

clear

echo -n 'Initializing Terraform ... '

echo "instana_agent_key=\"${INSTANA_AGENT_KEY}\"
instana_download_key=\"${INSTANA_AGENT_KEY}\"
instana_serverless_endpoint=\"${INSTANA_ENDPOINT_URL}\"
project_id=\"${GOOGLE_CLOUD_PROJECT}\"
region=\"${GOOGLE_CLOUD_REGION}\"
" > local.auto.tfvars

if ! output=$(terraform init); then
    echo 'Failed:'
    echo "${output}"
    exit 1
else
    echo 'OK'
fi

echo 'Applying Terraform ... '

function finish {
    echo "Cleaning up (invoking 'terraform destroy -auto-approve')"
    terraform destroy -auto-approve
}
trap finish EXIT

terraform apply -auto-approve

readonly loadgen_url=$(cat entrypoint_url)

echo
echo "Demo entry point is available at: ${loadgen_url}"

echo
echo 'Preparing load generator ... '

(cd load-gen && npm install > /dev/null 2>&1)

echo
echo 'Starting the load generation'

(cd load-gen && ENDPOINT_SERVICE_URL=${loadgen_url} npm start)