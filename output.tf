output "nodejs_url" {
  value = google_cloud_run_service.nodejs.status[0].url
}

output "java_url" {
  value = google_cloud_run_service.java.status[0].url
}

output "go_url" {
  value = google_cloud_run_service.go.status[0].url
}

output "dotnet_url" {
  value = google_cloud_run_service.dotnet.status[0].url
}
