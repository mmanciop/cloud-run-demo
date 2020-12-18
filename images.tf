data "docker_registry_image" "instana_cnb" {
  name = "containers.instana.io/instana/release/google/buildpack"
}

resource "docker_image" "instana_cnb" {
  name = data.docker_registry_image.instana_cnb.name
  pull_triggers = ["${data.docker_registry_image.instana_cnb.sha256_digest}"]
}

data "external" "hash_nodejs" {
  program = ["scripts/hash.sh", "${path.module}/nodejs-web"]
}

resource "null_resource" "image_nodejs" {
  triggers = {
    hash = data.external.hash_nodejs.result.hash
  }

  provisioner "local-exec" {
    command     = "pack build ${data.google_container_registry_image.nodejs.image_url}:${substr(data.external.hash_nodejs.result.hash, 0, 5)} --buildpack from=builder --buildpack containers.instana.io/instana/release/google/buildpack --builder gcr.io/buildpacks/builder && docker push ${data.google_container_registry_image.nodejs.image_url}:${substr(data.external.hash_nodejs.result.hash, 0, 5)}"
    working_dir = "nodejs-web"
  }

  depends_on = [
    docker_image.instana_cnb
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
    command     = "pack build ${data.google_container_registry_image.java.image_url}:${substr(data.external.hash_java.result.hash, 0, 5)} --buildpack from=builder --buildpack containers.instana.io/instana/release/google/buildpack --builder gcr.io/buildpacks/builder && docker push ${data.google_container_registry_image.java.image_url}:${substr(data.external.hash_java.result.hash, 0, 5)}"
    working_dir = "java-consumer"
  }

  depends_on = [
    docker_image.instana_cnb
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
    command     = "gcloud builds submit --project ${var.project_id} --tag ${data.google_container_registry_image.go.image_url}:${substr(data.external.hash_go.result.hash, 0, 5)}"
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
    command     = "pack build ${data.google_container_registry_image.dotnet.image_url}:${substr(data.external.hash_dotnet.result.hash, 0, 5)} --buildpack from=builder --buildpack containers.instana.io/instana/release/google/buildpack --builder gcr.io/buildpacks/builder && docker push ${data.google_container_registry_image.dotnet.image_url}:${substr(data.external.hash_dotnet.result.hash, 0, 5)}"
    working_dir = "dotnet-gcs"
  }

  depends_on = [
    docker_image.instana_cnb
  ]
}
