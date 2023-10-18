data "confluent_kafka_cluster" "cluster" {
  id = var.cluster_name
  environment {
    id = var.environment_id
  }
}
