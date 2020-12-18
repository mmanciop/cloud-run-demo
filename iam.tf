resource "google_project_iam_binding" "cloudbuild_secret_access" {
  role = "roles/secretmanager.secretAccessor"

  members = [
    "serviceAccount:${data.google_project.project.number}@cloudbuild.gserviceaccount.com",
  ]

  depends_on = [google_project_service.cloudbuild]
}

resource "google_project_iam_binding" "compute_pubsub_admin" {
  role = "roles/pubsub.admin"

  members = [
    "serviceAccount:${data.google_project.project.number}-compute@developer.gserviceaccount.com",
    "serviceAccount:${var.prefix}-${random_string.uid.result}-gcp-monitor@${var.project}.iam.gserviceaccount.com"
  ]
}

resource "google_project_iam_binding" "default_access" {
  role = "roles/viewer"

  members = [
    "group:dev@instana.com",
    "group:qa@instana.com",
  ]
}
