resource "google_cloud_scheduler_job" "load" {
  name             = "${var.prefix}-${random_string.uid.result}-scheduler"
  description      = "http trigger job for ${var.prefix}-${random_string.uid.result}"
  schedule         = "* * * * *"
  time_zone        = "Europe/Berlin"
  attempt_deadline = "320s"

  region = var.scheduler_region

  retry_config {
    retry_count = 1
  }

  http_target {
    http_method = "GET"
    uri         = join("", [google_cloud_run_service.nodejs.status[0].url, "/"])
  }
}
