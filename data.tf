data "confluent_kafka_cluster" "cluster" {
  display_name = var.cluster_name
  environment {
    id = var.environment_id
  }
}

data "confluent_service_account" "topic_service_account" {
  display_name = var.service_account_name
}