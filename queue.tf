resource "google_pubsub_topic" "queue" {
  name = "${var.prefix}-${random_string.uid.result}-topic"
}

resource "google_pubsub_subscription" "pull" {
  name  = "${var.prefix}-${random_string.uid.result}-pull"
  topic = google_pubsub_topic.queue.name

  ack_deadline_seconds = 20

  labels = {
    consumer = "java"
  }
}

resource "google_pubsub_subscription" "netcore-pull" {
  name  = "${var.prefix}-${random_string.uid.result}-netcore-pull"
  topic = google_pubsub_topic.queue.name

  ack_deadline_seconds = 20

  labels = {
    consumer = "netcore"
  }
}
