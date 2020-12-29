# Cloud Run Composite Example

[![Run on Google Cloud](https://deploy.cloud.run/button.svg)](https://deploy.cloud.run)

## Development

1. Open Cloud Shell with this link: https://console.cloud.google.com/cloudshell/open?cloudshell_image=gcr.io/graphite-cloud-shell-images/terraform:0.12

2. Create a new project, if the user have the right credentials:

   ```sh
   export PROJECT="<project-name>"
   gcloud projects create "${PROJECT}"
   gcloud config set project $(gcloud projects list --filter="${PROJECT}" --format="value(NAME, PROJECT_ID)" | grep "${PROJECT}" | awk '{ print $2 }')
   gcloud services enable cloudbuild.googleapis.com compute.googleapis.com
   ```

3. Clone demo repo:

   ```sh
   git clone https://github.com/mmanciop/cloud-run-demo.git
   ```

4. ```bash
   cd cloud-run-demo

   terraform init

   terraform apply -auto-approve -var "project_id=${DEVSHELL_PROJECT_ID}"
   ```
