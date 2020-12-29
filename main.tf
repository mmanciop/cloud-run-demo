data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "random_string" "uid" {
  length = 5
  upper = false
  number = false
  lower = true
  special = false
}

resource "google_cloud_run_service" "nodejs" {
  name = "${var.prefix}-${random_string.uid.result}-nodejs"
  location = var.region

  metadata {
    annotations = {
      "run.googleapis.com/launch-stage" = "BETA"
    }
  }

  template {
    spec {
      containers {
        image = "${data.google_container_registry_image.nodejs.image_url}:${substr(data.external.hash_nodejs.result.hash, 0, 5)}"

        env {
          name = "GCP_PROJECT"
          value = var.project_id
        }

        env {
          name = "DOTNET_TARGET"
          value = google_cloud_run_service.dotnet.status[0].url
        }

        env {
          name = "INSTANA_ENDPOINT_URL"
          value = var.instana_serverless_endpoint
        }
        env {
          name = "INSTANA_AGENT_KEY"
          value = var.instana_agent_key
        }
        env {
          name = "INSTANA_ZONE"
          value = "gcp-${var.prefix}-${random_string.uid.result}"
        }
        env {
          name = "INSTANA_DEBUG"
          value = "1"
        }
        env {
          name = "GRPC_TARGET"
          value = substr(google_cloud_run_service.go.status[0].url, 8, length(google_cloud_run_service.go.status[0].url) - 8)
        }
      }
    }

    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale" = 5

        "run.googleapis.com/client-name" = "terraform"
      }
    }
  }

  traffic {
    percent = 100
    latest_revision = true
  }

  depends_on = [
    google_project_service.cloud-run,
    null_resource.image_nodejs
  ]
}

resource "google_cloud_run_service_iam_policy" "nodejs_noauth" {
  location = google_cloud_run_service.nodejs.location
  project = google_cloud_run_service.nodejs.project
  service = google_cloud_run_service.nodejs.name

  policy_data = data.google_iam_policy.noauth.policy_data
}

resource "google_cloud_run_service" "go" {
  name = "${var.prefix}-${random_string.uid.result}-go"
  location = var.region

  metadata {
    annotations = {
      "run.googleapis.com/launch-stage" = "BETA"
    }
  }

  template {
    spec {
      containers {
        image = "${data.google_container_registry_image.go.image_url}:${substr(data.external.hash_go.result.hash, 0, 5)}"

        env {
          name = "GCP_PROJECT"
          value = var.project_id
        }
        env {
          name = "PUBSUB_TOPIC"
          value = google_pubsub_topic.queue.name
        }
        env {
          name = "INSTANA_ENDPOINT_URL"
          value = var.instana_serverless_endpoint
        }
        env {
          name = "INSTANA_AGENT_KEY"
          value = var.instana_agent_key
        }
        env {
          name = "INSTANA_ZONE"
          value = "gcp-${var.prefix}-${random_string.uid.result}"
        }
        env {
          name = "INSTANA_DEBUG"
          value = "1"
        }
      }
    }

    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale" = 5

        "run.googleapis.com/client-name" = "terraform"
      }
    }
  }

  traffic {
    percent = 100
    latest_revision = true
  }

  depends_on = [
    google_project_service.cloud-run,
    null_resource.image_go
  ]
}

resource "google_cloud_run_service_iam_policy" "go_noauth" {
  location = google_cloud_run_service.go.location
  project = google_cloud_run_service.go.project
  service = google_cloud_run_service.go.name

  policy_data = data.google_iam_policy.noauth.policy_data
}

resource "google_cloud_run_service" "java" {
  name = "${var.prefix}-${random_string.uid.result}-java"
  location = var.region

  metadata {
    annotations = {
      "run.googleapis.com/launch-stage" = "BETA"
    }
  }

  template {
    spec {
      containers {
        image = "${data.google_container_registry_image.java.image_url}:${substr(data.external.hash_java.result.hash, 0, 5)}"

        env {
          name = "INSTANA_ZONE"
          value = "gcp-${var.prefix}-${random_string.uid.result}"
        }
        env {
          name = "INSTANA_ENDPOINT_URL"
          value = var.instana_serverless_endpoint
        }
        env {
          name = "INSTANA_AGENT_KEY"
          value = var.instana_agent_key
        }
        env {
          name = "INSTANA_DEBUG"
          value = "1"
        }
        env {
          name = "_JAVA_OPTIONS"
          value = "-Xmx264M"
        }
        env {
          name = "PUBSUB_TOPIC"
          value = google_pubsub_topic.queue.name
        }
        env {
          name = "PUBSUB_SUBSCRIPTION"
          value = google_pubsub_subscription.pull.name
        }

        resources {
          limits = {
            cpu = "4"
            memory = "1Gi"
          }
        }
      }
    }

    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale" = 1

        "run.googleapis.com/client-name" = "terraform"
      }
    }
  }

  traffic {
    percent = 100
    latest_revision = true
  }

  depends_on = [
    google_project_service.cloud-run,
    google_project_iam_binding.compute_pubsub_admin,
    null_resource.image_java
  ]
}

resource "google_cloud_run_service_iam_policy" "java_noauth" {
  location = google_cloud_run_service.java.location
  project = google_cloud_run_service.java.project
  service = google_cloud_run_service.java.name

  policy_data = data.google_iam_policy.noauth.policy_data
}

resource "google_cloud_run_service" "dotnet" {
  name = "${var.prefix}-${random_string.uid.result}-dotnet"
  location = var.region

  metadata {
    annotations = {
      "run.googleapis.com/launch-stage" = "BETA"
    }
  }

  template {
    spec {
      containers {
        image = "${data.google_container_registry_image.dotnet.image_url}:${substr(data.external.hash_dotnet.result.hash, 0, 5)}"

        env {
          name = "INSTANA_ZONE"
          value = "gcp-${var.prefix}-${random_string.uid.result}"
        }
        env {
          name = "INSTANA_ENDPOINT_URL"
          value = var.instana_serverless_endpoint
        }
        env {
          name = "INSTANA_AGENT_KEY"
          value = var.instana_agent_key
        }
        env {
          name = "INSTANA_LOG_LEVEL"
          value = "TRACE"
        }
        env {
          name = "GCS_BUCKET"
          value = google_storage_bucket.dotnet-target.name
        }
        env {
          name = "GCP_PROJECT"
          value = var.project_id
        }
        env {
          name = "PUBSUB_TOPIC"
          value = google_pubsub_topic.queue.name
        }
        env {
          name = "PUBSUB_SUBSCRIPTION"
          value = google_pubsub_subscription.netcore-pull.name
        }
      }
    }

    metadata {
      annotations = {
        "run.googleapis.com/client-name" = "terraform"
      }
    }
  }

  traffic {
    percent = 100
    latest_revision = true
  }

  depends_on = [
    google_project_service.cloud-run,
    null_resource.image_dotnet
  ]
}

resource "google_cloud_run_service_iam_policy" "dotnet_noauth" {
  location = google_cloud_run_service.dotnet.location
  project = google_cloud_run_service.dotnet.project
  service = google_cloud_run_service.dotnet.name

  policy_data = data.google_iam_policy.noauth.policy_data
}

resource "local_file" "entry_service_url" {
  content = google_cloud_run_service.nodejs.status[0].url
  filename = "entry_service_url"

  depends_on = [
    google_cloud_run_service.nodejs
  ]
}