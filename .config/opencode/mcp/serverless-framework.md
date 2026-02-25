---
name: serverless-framework
type: local
command: ["serverless", "mcp"]
requires_env: []
optional_env:
  - AWS_PROFILE
  - AWS_REGION
  - AWS_ACCESS_KEY_ID
  - AWS_SECRET_ACCESS_KEY
  - AWS_SESSION_TOKEN
env: {}
---

## Description

Official MCP server for the Serverless Framework (v4+). Provides observability,
resource discovery, log analysis, and documentation access for serverless applications
deployed via Serverless Framework, CloudFormation, or Terraform. Includes deep AWS
service introspection for Lambda, API Gateway, DynamoDB, SQS, S3, IAM, and more.

Bundled with the `serverless` npm package — no separate installation required.

## Tools provided

**Project & Resource Discovery**
- **list-projects** — List all serverless projects in a workspace (requires explicit user confirmation before searching)
- **list-resources** — Get all deployed resources for a service (supports `serverless-framework`, `cloudformation`, `terraform`)
- **service-summary** — Consolidated overview of a full application: resources, metrics, and errors in one call
- **deployment-history** — Retrieve CloudFormation/Serverless Framework deployment history for the last 7 days

**Documentation**
- **docs** — Access up-to-date Serverless Framework (`sf`) and Serverless Container Framework (`scf`) documentation; returns doc tree or full markdown for specific paths

**AWS Lambda**
- **aws-lambda-info** — Function config, CloudWatch metrics (invocations, errors, throttles, duration, concurrency), and grouped error logs

**AWS API Gateway**
- **aws-rest-api-gateway-info** — REST API stages, resources, methods, integrations, deployments, API keys, usage plans, VPC links, and metrics
- **aws-http-api-gateway-info** — HTTP API routes, integrations, authorizers, logging config, and latency/error metrics

**AWS Storage & Messaging**
- **aws-dynamodb-info** — Table config, throughput, indexes, PITR backup, Kinesis streams, resource policies, metrics, and TTL settings
- **aws-s3-info** — Bucket config, ACL, policy, encryption, versioning, public access settings, and metrics
- **aws-sqs-info** — Queue config (visibility timeout, retention), DLQ config, and CloudWatch metrics

**AWS IAM**
- **aws-iam-info** — Role configuration, trust policies, attached managed policies, and inline policies

**CloudWatch Logs & Alarms**
- **aws-logs-search** — Search multiple log groups using CloudWatch Logs Insights (paid API); OR-logic across search terms
- **aws-logs-tail** — Retrieve recent logs via FilterLogEvents (free API); supports CloudWatch filter pattern syntax
- **aws-errors-info** — Analyze and group error patterns across log groups; supports service-wide or per-log-group analysis
- **aws-cloudwatch-alarms** — Get alarm configurations, current states, and state change history

## When to use

- Getting a full overview of a deployed serverless application
- Tailing or searching CloudWatch logs for debugging
- Analyzing error patterns across Lambda functions or a whole service
- Inspecting DynamoDB tables, SQS queues, S3 buckets, or API Gateway configs
- Checking IAM role permissions for serverless resources
- Reviewing CloudFormation or Serverless Framework deployment history
- Looking up Serverless Framework or Serverless Container Framework documentation

## Caveats

- Requires `serverless` npm package v4+ installed globally (`npm install -g serverless`)
- `list-projects` requires explicit user confirmation (`userConfirmed: true`) before scanning the workspace
- `aws-logs-search` uses CloudWatch Logs Insights which incurs AWS charges per GB scanned
- `aws-errors-info` requires a `confirmationToken` for time ranges exceeding 3 hours
- Uses the standard AWS credential chain — no dedicated env vars needed, but `AWS_PROFILE` and `AWS_REGION` are respected; each tool also accepts per-call `profile` and `region` parameters
- AWS SSO is supported: run `aws configure sso` then `aws sso login --profile <name>`

## Setup

Install the Serverless Framework globally (v4+):

```sh
npm install -g serverless
```

Configure AWS credentials via `~/.aws/credentials`, environment variables, or AWS SSO.
Optionally add to `~/.config/opencode/opencode.env`:

```
AWS_PROFILE=your-profile-name
AWS_REGION=us-east-1
```

## opencode.jsonc config

```jsonc
"serverless-framework": {
  "type": "local",
  "command": ["serverless", "mcp"]
}
```

To pass a specific AWS profile or region as environment variables:

```jsonc
"serverless-framework": {
  "type": "local",
  "command": ["serverless", "mcp"],
  "environment": {
    "AWS_PROFILE": "your-profile-name",
    "AWS_REGION": "us-east-1"
  }
}
```
