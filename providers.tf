provider "google" {
  version = "3.45.0"
  project = var.project
  zone = var.zone
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
