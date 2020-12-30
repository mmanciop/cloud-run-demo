#!/bin/bash

set -euxo pipefail

readonly loadgen_url=$( \
    gcloud run services describe \
        --platform=managed \
        --project="${GOOGLE_CLOUD_PROJECT}" \
        --region="${GOOGLE_CLOUD_REGION}" \
        "${K_SERVICE}" \
        --format json \
    | jq -r --exit-status '.status.address.url' \
)

echo "Demo entry point is available at: ${loadgen_url}"

echo 'Preparing load generator ... '

(cd load-gen && npm install > /dev/null)

(cd load-gen && ENDPOINT_SERVICE_URL=${loadgen_url} npm start)