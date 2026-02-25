---
name: aws-timestream-influxdb
type: local
command: ["uvx", "awslabs.timestream-for-influxdb-mcp-server@latest"]
requires_env:
  - AWS_REGION
optional_env:
  - AWS_PROFILE
  - INFLUXDB_URL
  - INFLUXDB_TOKEN
  - INFLUXDB_ORG
  - FASTMCP_LOG_LEVEL
env:
  AWS_PROFILE: "{env:AWS_PROFILE}"
  AWS_REGION: "{env:AWS_REGION}"
  INFLUXDB_URL: "{env:INFLUXDB_URL}"
  INFLUXDB_TOKEN: "{env:INFLUXDB_TOKEN}"
  INFLUXDB_ORG: "{env:INFLUXDB_ORG}"
  FASTMCP_LOG_LEVEL: "ERROR"
---

## Description

The official AWS Labs MCP server for Amazon Timestream for InfluxDB. Provides tools to create and manage Timestream for InfluxDB database instances and clusters, manage parameter groups and tags, and interact directly with InfluxDB 2 write/query APIs for time-series data operations.

## Tools provided

**Cluster Management**
- `CreateDbCluster` - Create a new Timestream for InfluxDB database cluster
- `GetDbCluster` - Retrieve information about a specific DB cluster
- `UpdateDbCluster` - Update a Timestream for InfluxDB database cluster
- `DeleteDbCluster` - Delete a Timestream for InfluxDB database cluster
- `ListDbClusters` - List all Timestream for InfluxDB database clusters
- `ListDbInstancesForCluster` - List DB instances belonging to a specific cluster
- `ListClustersByStatus` - List DB clusters filtered by status

**Instance Management**
- `CreateDbInstance` - Create a new Timestream for InfluxDB database instance
- `GetDbInstance` - Retrieve information about a specific DB instance
- `UpdateDbInstance` - Update a Timestream for InfluxDB database instance
- `DeleteDbInstance` - Delete a Timestream for InfluxDB database instance
- `ListDbInstances` - List all Timestream for InfluxDB database instances
- `ListDbInstancesByStatus` - List DB instances filtered by status

**Parameter Group Management**
- `CreateDbParamGroup` - Create a new DB parameter group
- `GetDbParameterGroup` - Retrieve information about a specific DB parameter group
- `ListDbParamGroups` - List all DB parameter groups

**Tag Management**
- `ListTagsForResource` - List all tags on a Timestream for InfluxDB resource
- `TagResource` - Add tags to a Timestream for InfluxDB resource
- `UntagResource` - Remove tags from a Timestream for InfluxDB resource

**InfluxDB Write API**
- `InfluxDBWritePoints` - Write data points to InfluxDB
- `InfluxDBWriteLP` - Write data in Line Protocol format to InfluxDB

**InfluxDB Query API**
- `InfluxDBQuery` - Query data from InfluxDB using Flux query language

**InfluxDB Bucket Management**
- `InfluxDBListBuckets` - List all buckets in InfluxDB
- `InfluxDBCreateBucket` - Create a new bucket in InfluxDB

**InfluxDB Organization Management**
- `InfluxDBListOrgs` - List all organizations in InfluxDB
- `InfluxDBCreateOrg` - Create a new organization in InfluxDB

## When to use

- Provisioning, inspecting, or tearing down Timestream for InfluxDB instances or clusters in AWS.
- Managing InfluxDB parameter groups or applying resource tags for cost allocation.
- Writing time-series data points (structured or raw Line Protocol) to an InfluxDB endpoint.
- Querying time-series data using Flux from an existing InfluxDB deployment.
- Managing InfluxDB buckets and organizations programmatically.

## Caveats

- `INFLUXDB_URL`, `INFLUXDB_TOKEN`, and `INFLUXDB_ORG` are only required for the InfluxDB data-plane tools (write, query, bucket, org management); AWS management-plane tools only need AWS credentials.
- AWS credentials must have appropriate IAM permissions for Timestream for InfluxDB. Start with read-only permissions if you do not want the LLM to modify resources.
- InfluxDB data operations target InfluxDB 2 APIs only; InfluxDB 1.x is not supported.
- The server uses `uv`/`uvx` — Python 3.10+ must be available via `uv`.

## Setup

1. Install `uv`: https://docs.astral.sh/uv/getting-started/installation/
2. Install Python 3.10+: `uv python install 3.10`
3. Configure AWS credentials: `aws configure` or set `AWS_PROFILE` and `AWS_REGION`.
4. For InfluxDB data-plane operations, set `INFLUXDB_URL`, `INFLUXDB_TOKEN`, and `INFLUXDB_ORG` pointing to your Timestream for InfluxDB endpoint.

## opencode.jsonc config

```jsonc
"aws-timestream-influxdb": {
  "type": "local",
  "command": ["uvx", "awslabs.timestream-for-influxdb-mcp-server@latest"],
  "env": {
    "AWS_PROFILE": "default",
    "AWS_REGION": "us-east-1",
    "INFLUXDB_URL": "https://your-influxdb-endpoint:8086",
    "INFLUXDB_TOKEN": "your-influxdb-token",
    "INFLUXDB_ORG": "your-influxdb-org",
    "FASTMCP_LOG_LEVEL": "ERROR"
  }
}
```
