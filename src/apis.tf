data "google_project" "project" {
}

resource "google_project_service" "cloudbuild" {
  service = "cloudbuild.googleapis.com"

  disable_dependent_services = true
}

resource "google_project_service" "cloud-run" {
  service = "run.googleapis.com"

  disable_dependent_services = true
}

resource "google_project_service" "secret-manager" {
  service = "secretmanager.googleapis.com"

  disable_dependent_services = true
}

resource "google_project_service" "cloud-resource-manager" {
  service = "cloudresourcemanager.googleapis.com"

  disable_dependent_services = true
}

resource "google_project_service" "monitoring" {
  service = "monitoring.googleapis.com"

  disable_dependent_services = true
}

resource "google_project_service" "sql" {
  service = "sqladmin.googleapis.com"

  disable_dependent_services = true
}
