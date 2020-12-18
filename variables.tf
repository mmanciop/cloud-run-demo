terraform {
  experiments = [variable_validation]
}

variable "prefix" {
  type = string
  description = "A prefix for the project resources to enable double-creation."
  default = "demo"
}

variable "project_id" {
  type = string
  description = "The GCP project-id where the services should be deployed to."
}

variable "region" {
  default = "europe-west4"
}

variable "instana_serverless_endpoint" {
  description = "The URL of your Instana's serverless acceptor."

  validation {
    condition     = can(regex("^https?(?://(?P<authority>[^/?#]*))?", var.instana_serverless_endpoint))
    error_message = "The instana_serverless_endpoint value must be a valid URL using the http or https scheme, without authentication, path or query parameters."
  }
}

variable "instana_agent_key" {
  description = "The Agent Key to be used to authenticate against the Instana backend."
}

variable "instana_download_key" {
  description = "The Download Key to be used to download the Instana Cloud Native Buildpack; unless you are running a self-managed (a.k.a. on-premise) Instana backend, it is the same as the Agent Key."
}
