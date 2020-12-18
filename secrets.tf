resource "google_secret_manager_secret" "download_key" {
  secret_id = "${var.prefix}_${random_string.uid.result}_instana_download_key"

  replication {
    automatic = true
  }

  depends_on = [
    google_project_service.secret-manager,
    random_string.uid
  ]
}

resource "google_secret_manager_secret_version" "download_key" {
  secret = google_secret_manager_secret.download_key.id

  secret_data = var.download_key
}

resource "google_secret_manager_secret" "agent_key" {
  secret_id = "${var.prefix}_${random_string.uid.result}_instana_agent_key"

  replication {
    automatic = true
  }

  depends_on = [
    google_project_service.secret-manager,
    random_string.uid]
}

resource "google_secret_manager_secret_version" "agent_key" {
  secret = google_secret_manager_secret.agent_key.id

  secret_data = var.agent_key
}
