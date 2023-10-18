# terraform-confluent-official-kafka-topics
Module for managing Confluent Kafka topics

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_confluent"></a> [confluent](#requirement\_confluent) | >=1.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_confluent"></a> [confluent](#provider\_confluent) | >=1.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [confluent_api_key.topic_api_key](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/api_key) | resource |
| [confluent_kafka_acl.group_readers](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/kafka_acl) | resource |
| [confluent_kafka_acl.readers](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/kafka_acl) | resource |
| [confluent_kafka_acl.writers](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/kafka_acl) | resource |
| [confluent_kafka_topic.topics](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/kafka_topic) | resource |
| [confluent_kafka_cluster.cluster](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/data-sources/kafka_cluster) | data source |
| [confluent_service_account.topic_service_account](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/data-sources/service_account) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Confluent Cloud cluster name | `string` | n/a | yes |
| <a name="input_environment_id"></a> [environment\_id](#input\_environment\_id) | Confluent Cloud environment id | `string` | n/a | yes |
| <a name="input_service_account_name"></a> [service\_account\_name](#input\_service\_account\_name) | Service account to generate credentials used to create and manage topics | `string` | n/a | yes |
| <a name="input_topics"></a> [topics](#input\_topics) | Kafka topic definitions.<br>  Object map keyed by topic name with topic configuration values as well as reader and writer ACL lists.<br>  Values provided to the ACL lists will become service accounts with { key, secret } objects output by service\_account\_credentials | <pre>map(<br>    object({<br>      replication_factor = number<br>      partitions         = number<br>      config             = map(any)<br>      acl_readers        = list(string)<br>      acl_writers        = list(string)<br>    })<br>  )</pre> | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->