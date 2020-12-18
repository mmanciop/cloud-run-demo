resource "google_secret_manager_secret" "instana_download_key" {
  secret_id = "${var.prefix}_${random_string.uid.result}_instana_download_key"

  replication {
    automatic = true
  }

  depends_on = [
    google_project_service.secret-manager,
    random_string.uid
  ]
}

resource "google_secret_manager_secret_version" "instana_download_key" {
  secret = google_secret_manager_secret.instana_download_key.id

  secret_data = var.instana_download_key
}

resource "google_secret_manager_secret" "instana_agent_key" {
  secret_id = "${var.prefix}_${random_string.uid.result}_instana_agent_key"

  replication {
    automatic = true
  }

  depends_on = [
    google_project_service.secret-manager,
    random_string.uid]
}

resource "google_secret_manager_secret_version" "instana_agent_key" {
  secret = google_secret_manager_secret.instana_agent_key.id

  secret_data = var.instana_agent_key
}
