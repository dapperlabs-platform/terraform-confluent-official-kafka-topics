data "confluent_kafka_cluster" "cluster" {
  display_name = var.cluster_name
  environment {
    id = data.confluent_environment.environment.id
  }
}

data "confluent_environment" "environment" {
  display_name = var.environment_name
}

data "confluent_service_account" "topic_service_account" {
  display_name = var.service_account_name
}