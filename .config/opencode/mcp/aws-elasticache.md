---
name: aws-elasticache
type: local
command: ["uvx", "awslabs.elasticache-mcp-server@latest"]
requires_env:
  - AWS_REGION
optional_env:
  - AWS_PROFILE
  - FASTMCP_LOG_LEVEL
  - ELASTICACHE_MAX_RETRIES
  - ELASTICACHE_RETRY_MODE
  - ELASTICACHE_CONNECT_TIMEOUT
  - ELASTICACHE_READ_TIMEOUT
env:
  AWS_PROFILE: "{env:AWS_PROFILE}"
  AWS_REGION: "{env:AWS_REGION}"
  FASTMCP_LOG_LEVEL: "ERROR"
---

## Description

The official AWS ElastiCache MCP Server for managing ElastiCache control-plane resources. Supports serverless caches, replication groups, and cache clusters, plus CloudWatch metrics/logs, Kinesis Firehose, and Cost Explorer — all via direct AWS API calls.

## Tools provided

**Serverless Cache Operations**
- `create-serverless-cache` - Create a new serverless cache
- `delete-serverless-cache` - Delete a serverless cache
- `describe-serverless-caches` - List and describe serverless caches
- `modify-serverless-cache` - Update settings of a serverless cache
- `connect-jump-host-serverless-cache` - Configure an EC2 instance as a jump host for serverless cache access
- `create-jump-host-serverless-cache` - Provision an EC2 jump host with SSH tunnel to a serverless cache
- `get-ssh-tunnel-command-serverless-cache` - Generate the SSH tunnel command for serverless cache access

**Replication Group Operations**
- `create-replication-group` - Create a Redis replication group
- `delete-replication-group` - Delete a replication group (optional final snapshot)
- `describe-replication-groups` - Describe one or more replication groups
- `modify-replication-group` - Modify replication group settings
- `modify-replication-group-shard-configuration` - Reshape shards on an existing replication group
- `test-migration` / `start-migration` / `complete-migration` - Migrate from a self-managed Redis instance to ElastiCache
- `connect-jump-host-replication-group` / `create-jump-host-replication-group` / `get-ssh-tunnel-command-replication-group` - Jump-host helpers for replication group access

**Cache Cluster Operations**
- `create-cache-cluster` - Create a standalone cache cluster
- `delete-cache-cluster` - Delete a cluster (optional final snapshot)
- `describe-cache-clusters` - Describe one or more clusters
- `modify-cache-cluster` - Modify cluster settings
- `connect-jump-host-cache-cluster` / `create-jump-host-cache-cluster` / `get-ssh-tunnel-command-cache-cluster` - Jump-host helpers for cluster access

**CloudWatch Operations**
- `get-metric-statistics` - Retrieve CloudWatch metric statistics for ElastiCache resources

**CloudWatch Logs Operations**
- `describe-log-groups` - List CloudWatch Logs log groups
- `create-log-group` - Create a log group
- `describe-log-streams` - List log streams within a log group
- `filter-log-events` - Search/filter log events
- `get-log-events` - Retrieve events from a specific log stream

**Firehose Operations**
- `list-delivery-streams` - List Kinesis Data Firehose delivery streams

**Cost Explorer Operations**
- `get-cost-and-usage` - Retrieve cost and usage data for ElastiCache resources

**Misc Operations**
- `describe-cache-engine-versions` - List available Redis/Memcached engine versions
- `describe-engine-default-parameters` - Get default parameters for a cache engine family
- `describe-events` - Retrieve events for clusters, security groups, and parameter groups
- `describe-service-updates` - List available service updates
- `batch-apply-update-action` / `batch-stop-update-action` - Apply or stop service updates across resources

## When to use

- Inspecting, creating, or modifying ElastiCache serverless caches, replication groups, or cache clusters.
- Setting up SSH jump-host tunnels to access private ElastiCache endpoints during development or debugging.
- Migrating a self-managed Redis workload to an ElastiCache replication group.
- Pulling CloudWatch metrics or logs to diagnose performance issues or cache hit rates.
- Reviewing ElastiCache cost and usage via Cost Explorer.
- Applying or halting AWS service updates across ElastiCache resources.

## Caveats

- This server manages the **control plane only**. To read/write data inside caches use the [Valkey MCP Server](https://github.com/awslabs/mcp/blob/main/src/valkey-mcp-server) or [Memcached MCP Server](https://github.com/awslabs/mcp/blob/main/src/memcached-mcp-server) instead.
- Jump-host tools create real EC2 instances and incur AWS costs; delete them when finished.
- Pass `--readonly` as an extra arg to block all mutating (Create/Modify/Delete) operations.
- Region defaults to `us-west-2` if `AWS_REGION` is not set.
- AWS credentials must have appropriate IAM permissions for ElastiCache, CloudWatch, Firehose, and Cost Explorer as needed.

## Setup

1. Install `uv`: https://docs.astral.sh/uv/getting-started/installation/
2. Install Python 3.10: `uv python install 3.10`
3. Configure AWS credentials (`aws configure` or set `AWS_PROFILE` / `AWS_REGION`).
4. Optionally restrict to read-only by adding `"--readonly"` to the `args` list in the config below.

## opencode.jsonc config

```jsonc
"aws-elasticache": {
  "type": "local",
  "command": ["uvx", "awslabs.elasticache-mcp-server@latest"],
  "env": {
    "AWS_PROFILE": "default",
    "AWS_REGION": "us-east-1",
    "FASTMCP_LOG_LEVEL": "ERROR"
  }
}
```
