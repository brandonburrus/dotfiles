---
name: aws-serverless
type: local
command: ["uvx", "awslabs.aws-serverless-mcp-server@latest", "--allow-write", "--allow-sensitive-data-access"]
requires_env: []
optional_env:
  - AWS_PROFILE
  - AWS_REGION
  - AWS_ACCESS_KEY_ID
  - AWS_SECRET_ACCESS_KEY
  - AWS_SESSION_TOKEN
  - FASTMCP_LOG_LEVEL
env:
  AWS_REGION: "{env:AWS_REGION}"
  AWS_PROFILE: "{env:AWS_PROFILE}"
  FASTMCP_LOG_LEVEL: "ERROR"
---

## Description

MCP server for building, deploying, and managing AWS serverless applications. Combines
AI assistance with serverless expertise across the full application lifecycle: SAM
project initialization, build, deploy, local invocation, observability, web app
deployment via Lambda Web Adapter, EventBridge schema discovery, and Event Source
Mapping (ESM) configuration/optimization.

Runs in read-only mode by default. Pass `--allow-write` to enable deployments and
`--allow-sensitive-data-access` to enable log retrieval.

## Tools provided

**SAM Lifecycle**
- **sam_init** — Initialize a new SAM project with runtime, architecture, and template options
- **sam_build** — Compile Lambda code and produce deployment artifacts
- **sam_deploy** — Deploy a SAM application to AWS via CloudFormation (requires `--allow-write`)
- **sam_logs** — Fetch CloudWatch logs for SAM resources (requires `--allow-sensitive-data-access`)
- **sam_local_invoke** — Invoke a Lambda function locally in a Docker container

**Web Application Deployment**
- **deploy_webapp** — Deploy full-stack, frontend, or backend web apps using Lambda Web Adapter (Express, Next.js, etc.)
- **configure_domain** — Set up a custom domain with Route 53, ACM certificate, and CloudFront mapping
- **update_webapp_frontend** — Upload new frontend assets to S3 and optionally invalidate CloudFront cache
- **webapp_deployment_help** — Get help and guidance for web app deployment types

**Observability**
- **get_metrics** — Retrieve CloudWatch metrics (error rates, latency, concurrency) for a deployed app

**Guidance & Templates**
- **get_lambda_guidance** — Determine if Lambda is the right compute platform for a use case
- **get_iac_guidance** — Choose between SAM, CDK, CloudFormation, or Terraform for a project
- **get_serverless_templates** — Fetch example SAM templates from Serverless Land by type and runtime
- **deploy_serverless_app_help** — Get step-by-step deployment instructions by application type

**EventBridge Schema Registry**
- **list_registries** — List schema registries in the account
- **search_schema** — Search schemas by keyword (use "aws.events" registry for AWS service events)
- **describe_schema** — Retrieve full schema definition for type-safe Lambda handler generation

**Event Source Mapping (ESM)**
- **esm_guidance** — Setup, networking, and troubleshooting guidance for DynamoDB, Kinesis, Kafka, SQS ESMs
- **esm_optimize** — Analyze, validate, and generate optimized SAM templates for ESM configurations
- **esm_kafka_troubleshoot** — Diagnose and resolve Kafka ESM connectivity, auth, and performance issues

## When to use

- Initializing, building, or deploying SAM serverless applications
- Deploying web apps (Express, Next.js, Flask, etc.) to Lambda without framework adapters
- Retrieving logs and metrics from serverless resources for debugging
- Deciding between Lambda vs other compute, or SAM vs CDK vs Terraform
- Fetching SAM templates from Serverless Land as starting points
- Working with EventBridge events and needing type-safe Lambda handler schemas
- Configuring or troubleshooting Kinesis, DynamoDB, SQS, or Kafka ESM triggers
- Optimizing ESM batch size, parallelization, and concurrency settings

## Caveats

- **Write operations are disabled by default** — pass `--allow-write` to enable `sam_deploy`, `deploy_webapp`, `configure_domain`, `update_webapp_frontend`, and ESM deployment tools.
- **Log access is disabled by default** — pass `--allow-sensitive-data-access` to enable `sam_logs`.
- **ESM tools require user confirmation** before any deployment even with `--allow-write` enabled.
- `sam_local_invoke` and `sam_build --use-container` require Docker to be installed and running.
- `sam_*` tools require AWS SAM CLI to be installed separately (`brew install aws-sam-cli`).
- `deploy_webapp` requires Lambda Web Adapter support; the tool generates the SAM template automatically.
- Sensitive data (credentials, IPs, PII) is automatically scrubbed from logs and tool responses.

## Setup

Prerequisites (install once):

```sh
# Install uv (Python package runner)
curl -LsSf https://astral.sh/uv/install.sh | sh

# Install Python 3.10+
uv python install 3.10

# Install AWS SAM CLI
brew install aws-sam-cli

# Install AWS CLI
brew install awscli
```

Configure AWS credentials in `~/.aws/credentials` or set env vars. Optionally add to
`~/.config/opencode/opencode.env`:

```
AWS_PROFILE=your-profile-name
AWS_REGION=us-east-1
FASTMCP_LOG_LEVEL=ERROR
```

## opencode.jsonc config

```jsonc
"aws-serverless": {
  "type": "local",
  "command": [
    "uvx",
    "awslabs.aws-serverless-mcp-server@latest",
    "--allow-write",
    "--allow-sensitive-data-access"
  ],
  "environment": {
    "AWS_REGION": "us-east-1",
    "AWS_PROFILE": "default",
    "FASTMCP_LOG_LEVEL": "ERROR"
  }
}
```
