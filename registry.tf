data "google_container_registry_repository" "registry" {
}

data "google_container_registry_image" "nodejs" {
  name = "instana-${var.prefix}-${random_string.uid.result}/nodejs"
}

data "google_container_registry_image" "go" {
  name = "instana-${var.prefix}-${random_string.uid.result}/go"
}

data "google_container_registry_image" "java" {
  name = "instana-${var.prefix}-${random_string.uid.result}/java"
}

data "google_container_registry_image" "dotnet" {
  name = "instana-${var.prefix}-${random_string.uid.result}/dotnet"
}
