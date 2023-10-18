terraform {
  required_providers {
    confluent = {
      source  = "confluentinc/confluent"
      version = ">=1.0.0"
    }
  }
}

locals {
  topic_readers = flatten([
    for name, values in var.topics :
    [for user in values.acl_readers : { topic : name, user : user }]
  ])
  readers_map = { for v in local.topic_readers : "${v.topic}/${v.user}" => v }
  readers_set = toset([
    for r in local.topic_readers : r.user
  ])
  topic_writers = flatten([
    for name, values in var.topics :
    [for user in values.acl_writers : { topic : name, user : user }]
  ])
  writers_map = { for v in local.topic_writers : "${v.topic}/${v.user}" => v }
}

# Topic API Key
resource "confluent_api_key" "topic_api_key" {
  display_name = "${var.cluster_name}-topic-api-key"
  description  = "${var.cluster_name}-topic-api-key"
  owner {
    id          = data.confluent_service_account.topic_service_account.id
    api_version = data.confluent_service_account.topic_service_account.api_version
    kind        = data.confluent_service_account.topic_service_account.kind
  }

  managed_resource {
    id          = data.confluent_kafka_cluster.cluster.id
    api_version = data.confluent_kafka_cluster.cluster.api_version
    kind        = data.confluent_kafka_cluster.cluster.kind

    environment {
      id = data.confluent_environment.environment.id
    }
  }
}

# Topics
resource "confluent_kafka_topic" "topics" {
  for_each = var.topics
  kafka_cluster {
    id = data.confluent_kafka_cluster.cluster.id
  }
  topic_name       = each.key
  partitions_count = each.value.partitions
  rest_endpoint    = data.confluent_kafka_cluster.cluster.rest_endpoint
  config           = try(each.value.config, {})
  credentials {
    key    = confluent_api_key.topic_api_key.id
    secret = confluent_api_key.topic_api_key.secret
  }
}

# Topic Readers ACL
resource "confluent_kafka_acl" "readers" {
  for_each = local.readers_map

  kafka_cluster {
    id = data.confluent_kafka_cluster.cluster.id
  }
  resource_type = "TOPIC"
  resource_name = each.value.topic
  pattern_type  = "LITERAL"
  principal     = "User:${confluent_service_account.service_accounts[each.value.user].id}"
  host          = "*"
  operation     = "READ"
  permission    = "ALLOW"
  rest_endpoint = data.confluent_kafka_cluster.cluster.rest_endpoint
  credentials {
    key    = confluent_api_key.topic_api_key.id
    secret = confluent_api_key.topic_api_key.secret
  }
}

# Topic Writers ACL
resource "confluent_kafka_acl" "writers" {
  for_each = local.writers_map

  kafka_cluster {
    id = data.confluent_kafka_cluster.cluster.id
  }
  resource_type = "TOPIC"
  resource_name = each.value.topic
  pattern_type  = "LITERAL"
  principal     = "User:${confluent_service_account.service_accounts[each.value.user].id}"
  host          = "*"
  operation     = "WRITE"
  permission    = "ALLOW"
  rest_endpoint = data.confluent_kafka_cluster.cluster.rest_endpoint
  credentials {
    key    = confluent_api_key.topic_api_key.id
    secret = confluent_api_key.topic_api_key.secret
  }
}

# Group Readers ACL
resource "confluent_kafka_acl" "group_readers" {
  for_each = local.readers_set

  kafka_cluster {
    id = data.confluent_kafka_cluster.cluster.id
  }
  resource_type = "GROUP"
  resource_name = "*"
  pattern_type  = "LITERAL"
  principal     = "User:${confluent_service_account.service_accounts[each.value].id}"
  host          = "*"
  operation     = "READ"
  permission    = "ALLOW"
  rest_endpoint = data.confluent_kafka_cluster.cluster.rest_endpoint
  credentials {
    key    = confluent_api_key.topic_api_key.id
    secret = confluent_api_key.topic_api_key.secret
  }
}
