variable "cluster_name" {
  description = "Confluent Cloud cluster name"
  type        = string
}

variable "environment_name" {
  description = "Confluent Cloud environment name"
  type        = string
}

variable "service_account_name" {
  description = "Service account to generate credentials used to create and manage topics"
  type        = string
}

variable "topics" {
  description = <<EOF
  Kafka topic definitions.
  Object map keyed by topic name with topic configuration values as well as reader and writer ACL lists.
  Values provided to the ACL lists will become service accounts with { key, secret } objects output by service_account_credentials
  EOF
  type = map(
    object({
      replication_factor = number
      partitions         = number
      config             = map(any)
      acl_readers        = list(string)
      acl_writers        = list(string)
    })
  )
}