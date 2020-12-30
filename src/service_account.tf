# Service Account for the monitor VM

resource "google_service_account" "monitor" {
  account_id   = "${var.prefix}-${random_string.uid.result}-gcp-monitor"
  display_name = "Instana Monitor Service Account"
}
