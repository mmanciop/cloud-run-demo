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

curl "${loadgen_url}"