infra_env                  = "dev"
mysql_instance_class       = "db.t2.small"
rds_cluster_instance_count = "1"
stream_name                = "loveshark-dev"
kinesis_shard_count        = "1"
redis_node_type            = "cache.t2.small"
redis_nodes                = "2"
sns_platform_application   = "mochi-prototype-application"
sms_monthly_dollar_limit   = "100"
opensearch_instance_type   = "t3.small.elasticsearch"
opensearch_domain_name     = "test"