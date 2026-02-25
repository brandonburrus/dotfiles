---
name: aws-dataprocessing
type: local
command: ["uvx", "awslabs.aws-dataprocessing-mcp-server@latest"]
requires_env:
  - AWS_REGION
optional_env:
  - AWS_PROFILE
  - FASTMCP_LOG_LEVEL
  - CUSTOM_TAGS
env:
  AWS_PROFILE: "{env:AWS_PROFILE}"
  AWS_REGION: "{env:AWS_REGION}"
  FASTMCP_LOG_LEVEL: "ERROR"
---

## Description

The official AWS Data Processing MCP Server. Provides AI code assistants with comprehensive data processing tools and real-time pipeline visibility across AWS Glue, Amazon EMR (EC2 and Serverless), and Amazon Athena. Enables natural language management of ETL pipelines, big data analytics, data catalog operations, interactive Spark/Ray sessions, and SQL query execution.

## Tools provided

**Glue Data Catalog**
- `manage_aws_glue_databases` - Create, list, get, update, and delete Glue Data Catalog databases.
- `manage_aws_glue_tables` - Create, list, get, search, update, and delete Glue Data Catalog tables.
- `manage_aws_glue_connections` - Manage Glue Data Catalog connections to data sources.
- `manage_aws_glue_partitions` - Create, list, get, update, and delete table partitions.
- `manage_aws_glue_catalog` - Manage Glue catalogs including create, delete, get, list, and import operations.

**Glue ETL & Crawlers**
- `manage_aws_glue_jobs` - Create, run, stop, monitor, and manage Glue ETL jobs and job bookmarks.
- `manage_aws_glue_crawlers` - Create, start, stop, update, and list crawlers for automated data discovery.
- `manage_aws_glue_classifiers` - Manage classifiers that determine data formats and schemas.
- `manage_aws_glue_crawler_management` - Manage crawler schedules and monitor crawler performance metrics.

**Glue Interactive Sessions & Workflows**
- `manage_aws_glue_sessions` - Create, start, stop, and manage Glue Interactive Sessions for Spark/Ray.
- `manage_aws_glue_statements` - Run, cancel, and list code statements within Glue Interactive Sessions.
- `manage_aws_glue_workflows` - Orchestrate ETL pipelines through visual workflows; start/stop workflow runs.
- `manage_aws_glue_triggers` - Create scheduled, conditional, or event-based triggers for jobs and workflows.

**Glue Commons (Security & Config)**
- `manage_aws_glue_usage_profiles` - Manage Glue usage profiles for resource allocation and cost management.
- `manage_aws_glue_security_configurations` - Manage encryption configurations for Glue resources.
- `manage_aws_glue_encryption` - Get and put Glue Data Catalog encryption settings.
- `manage_aws_glue_resource_policies` - Get, put, and delete resource policies for Glue catalogs/databases/tables.

**EMR EC2**
- `manage_aws_emr_clusters` - Create, describe, modify, terminate, and list EMR clusters; manage security configurations.
- `manage_aws_emr_ec2_instances` - Add, modify, and list EMR instance fleets and instance groups.
- `manage_aws_emr_ec2_steps` - Add, cancel, describe, and list EMR steps (Hadoop, Spark, etc.).

**EMR Serverless**
- `manage_aws_emr_serverless_applications` - Create, update, delete, start, stop, and list EMR Serverless applications.
- `manage_aws_emr_serverless_job_runs` - Start, cancel, list, and retrieve dashboards for EMR Serverless job runs.

**Athena**
- `manage_aws_athena_query_executions` - Execute, monitor, retrieve results, and stop Athena SQL queries.
- `manage_aws_athena_named_queries` - Create, update, delete, and list saved SQL queries in Athena.
- `manage_aws_athena_data_catalogs` - Create, update, delete, and list Athena data catalogs (Glue, Lambda, Hive, Federated).
- `manage_aws_athena_databases_and_tables` - Browse Athena databases and table metadata for schema discovery.
- `manage_aws_athena_workgroups` - Create, update, delete, and list Athena workgroups for cost and access control.

**Common/Shared**
- `add_inline_policy` - Add an inline IAM policy to an existing role.
- `get_policies_for_role` - Retrieve managed and inline policies attached to an IAM role.
- `create_data_processing_role` - Create an IAM role with trust relationships for Glue, EMR, or Athena.
- `get_roles_for_service` - List IAM roles with a trust relationship for a specific AWS service.
- `list_s3_buckets` - List S3 buckets (filtered by name) with usage statistics and idle time analysis.
- `upload_to_s3` - Upload Python scripts or other content directly to an S3 bucket.
- `analyze_s3_usage_for_data_processing` - Identify S3 buckets used by Glue/EMR/Athena and flag idle buckets.

## When to use

- Managing AWS Glue Data Catalog (databases, tables, connections, partitions) via natural language.
- Creating, running, monitoring, and debugging Glue ETL jobs and crawlers.
- Orchestrating ETL workflows with Glue workflows and triggers.
- Launching and managing EMR clusters or Serverless applications for big data workloads.
- Submitting and monitoring EMR steps (Spark, Hadoop, Hive).
- Running, saving, and managing Athena SQL queries and workgroups.
- Creating IAM roles and S3 resources for data processing pipelines.
- Troubleshooting data processing pipelines through intelligent operational insights.

## Caveats

- **Read-only by default.** Mutating operations (create, update, delete, start, stop) require the `--allow-write` flag in the command args.
- **Sensitive data access** (logs, events) requires the `--allow-sensitive-data-access` flag.
- **Resource management limitation:** The server can only update or delete resources it originally created (tagged as MCP-managed). Set `CUSTOM_TAGS=true` to bypass tag verification — use with caution.
- **IAM permissions:** Read-only operations require a broad set of `glue:Get*`, `emr:Describe*`/`List*`, and `athena:Get*`/`List*` permissions. Write operations additionally require `AWSGlueServiceRole` or equivalent.
- Requires Python 3.10+ and `uv` installed on the host machine.
- AWS credentials must be configured (via `AWS_PROFILE`, environment variables, or EC2/ECS instance role).

## Setup

1. Install Python 3.10+: https://www.python.org/downloads/release/python-3100/
2. Install `uv`: https://docs.astral.sh/uv/getting-started/installation/
3. Configure AWS credentials: `aws configure` or set `AWS_PROFILE`/`AWS_REGION`.
4. Attach the required IAM policies to your AWS user or role:
   - **Read-only:** See the Read-Only Operations Policy in the server docs (covers `glue:Get*`, `emr:Describe*`, `athena:Get*`, etc.).
   - **Write:** Attach `AWSGlueServiceRole` (or equivalent) for mutating operations.
5. Add `--allow-write` to the command args to enable mutating operations (see config below).

## opencode.jsonc config

```jsonc
"aws-dataprocessing": {
  "type": "local",
  "command": ["uvx", "awslabs.aws-dataprocessing-mcp-server@latest", "--allow-write"],
  "env": {
    "AWS_PROFILE": "default",
    "AWS_REGION": "us-east-1",
    "FASTMCP_LOG_LEVEL": "ERROR"
  }
}
```
