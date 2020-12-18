variable "prefix" {
  type = string
  description = "A prefix for the project resources to enable double-creation"
  default = "demo"
}

variable "zone" {
  type = string
  description = "The zone where the services should be deployed to. Needs to support cloud run"
  default = "europe-west4-c"
}

variable "region" {
  default = "europe-west4"
}

variable "scheduler_region" {
  default = "europe-west1"
}

variable "project" {
  type = string
  description = "The zone where the services should be deployed to. Needs to support cloud run"
}

variable "serverless_endpoint" {
  description = "The URL of the serverless acceptor"
}

variable "agent_key" {
  description = "The Agent Key for this service"
}

variable "download_key" {
  description = "The Download Key for this service"
}
