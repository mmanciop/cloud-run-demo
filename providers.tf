provider "google" {
  version = "3.45.0"
  project = var.project_id
  region = var.region
}

provider "external" {
  version = "~> 2.0"
}

provider "null" {
  version = "~> 3.0"
}

provider "random" {
  version = "~> 3.0"
}

provider "docker" {
  host = "unix:///var/run/docker.sock"

  registry_auth {
    address = "containers.instana.io"
    username = "_"
    password = var.instana_download_key
  }
}
