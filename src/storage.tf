resource "google_storage_bucket" "dotnet-target" {
  name          = "${var.prefix}-${random_string.uid.result}-dotnet-bucket"
  location      = "US" # TODO Base this on region
  force_destroy = true

  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "Delete"
    }
  }
}
