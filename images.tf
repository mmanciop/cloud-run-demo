data "external" "hash_nodejs" {
  program = ["scripts/hash.sh", "${path.module}/nodejs-web"]
}

resource "null_resource" "image_nodejs" {
  triggers = {
    hash = data.external.hash_nodejs.result.hash
  }

  provisioner "local-exec" {
    command     = "gcloud builds submit --project ${var.project_id} --substitutions=_DOWNLOAD_KEY=${var.instana_download_key},_IMAGE_NAME=${data.google_container_registry_image.nodejs.image_url}"
    working_dir = "nodejs-web"
  }

  depends_on = [
    google_project_service.cloudbuild
  ]
}

data "external" "hash_java" {
  program = ["scripts/hash.sh", "${path.module}/java-consumer"]
}

resource "null_resource" "image_java" {
  triggers = {
    hash = data.external.hash_java.result.hash
  }

  provisioner "local-exec" {
    command     = "gcloud builds submit --project ${var.project_id} --substitutions=_DOWNLOAD_KEY=${var.instana_download_key},_IMAGE_NAME=${data.google_container_registry_image.java.image_url}"
    working_dir = "java-consumer"
  }

  depends_on = [
    google_project_service.cloudbuild
  ]
}

data "external" "hash_go" {
  program = ["scripts/hash.sh", "${path.module}/go-grpc"]
}

resource "null_resource" "image_go" {
  triggers = {
    hash = data.external.hash_go.result.hash
  }

  provisioner "local-exec" {
    command     = "gcloud builds submit --project ${var.project_id} --tag ${data.google_container_registry_image.go.image_url}"
    working_dir = "go-grpc"
  }

  depends_on = [
    google_project_service.cloudbuild
  ]
}

data "external" "hash_dotnet" {
  program = ["scripts/hash.sh", "${path.module}/dotnet-gcs"]
}

resource "null_resource" "image_dotnet" {
  triggers = {
    hash = data.external.hash_dotnet.result.hash
  }

  provisioner "local-exec" {
    command     = "gcloud builds submit --project ${var.project_id} --substitutions=_DOWNLOAD_KEY=${var.instana_download_key},_IMAGE_NAME=${data.google_container_registry_image.dotnet.image_url}"
    working_dir = "dotnet-gcs"
  }

  depends_on = [
    google_project_service.cloudbuild
  ]
}
