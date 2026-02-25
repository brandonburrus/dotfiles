---
name: aws-ecs
type: local
command: ["uvx", "--from", "awslabs-ecs-mcp-server", "ecs-mcp-server"]
requires_env: []
optional_env:
  - AWS_PROFILE
  - AWS_REGION
  - FASTMCP_LOG_LEVEL
  - FASTMCP_LOG_FILE
optional_env_notes:
  ALLOW_WRITE: "Set to 'true' to enable write/mutating operations (default: false)"
  ALLOW_SENSITIVE_DATA: "Set to 'true' to enable log and detailed resource access (default: false)"
env:
  AWS_PROFILE: "{env:AWS_PROFILE}"
  AWS_REGION: "{env:AWS_REGION}"
  FASTMCP_LOG_LEVEL: "ERROR"
  ALLOW_WRITE: "false"
  ALLOW_SENSITIVE_DATA: "false"
---

## Description

The Amazon ECS MCP Server enables AI assistants to manage the full lifecycle of containerized
applications on AWS ECS. It provides tools for containerizing web apps, deploying via ECS
Express Mode (automatic infrastructure provisioning), ECR image management, deployment
troubleshooting, and comprehensive ECS resource management.

Runs in **read-only, non-sensitive mode by default**. Set `ALLOW_WRITE=true` to enable
mutating operations, and `ALLOW_SENSITIVE_DATA=true` to enable log/detailed resource access.

> A fully managed AWS-hosted version is also available with automatic updates and IAM-based
> security. See [AWS docs](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-mcp-getting-started.html).

## Tools provided

### Express Mode Deployment
- `containerize_app` — Generate Dockerfile and container configs for web apps with best practices
- `build_and_push_image_to_ecr` — Create ECR repo via CloudFormation, build Docker image, and push; returns `full_image_uri`
- `validate_ecs_express_mode_prerequisites` — Verify Task Execution Role, Infrastructure Role, and ECR image exist before deployment
- `wait_for_service_ready` — Poll service status every 10 seconds until tasks reach RUNNING state
- `delete_app` — Delete complete Express Mode deployment including ECR CloudFormation stack

### Troubleshooting
- `ecs_troubleshooting_tool` — Consolidated diagnostic tool with actions:
  - `get_ecs_troubleshooting_guidance` — Initial assessment and troubleshooting path recommendation
  - `fetch_cloudformation_status` — Infrastructure-level CloudFormation stack diagnostics
  - `fetch_service_events` — Service-level ECS service event diagnostics
  - `fetch_task_failures` — Task-level failure diagnostics
  - `fetch_task_logs` — Application-level CloudWatch log diagnostics (requires `ALLOW_SENSITIVE_DATA=true`)
  - `detect_image_pull_failures` — Specialized container image pull failure detection
  - `fetch_network_configuration` — VPC, subnet, security group, and load balancer diagnostics

### Resource Management
- `ecs_resource_management` — Unified interface for ECS/ECR resources:
  - **Read** (always available): List/describe clusters, services, tasks, task definitions, container instances, capacity providers, service deployments, Express Gateway Services, ECR repos/images
  - **Write** (requires `ALLOW_WRITE=true`): Create/update/delete clusters, services, task definitions, capacity providers; run/start/stop tasks; register/deregister task definitions and container instances; tag management; Express Gateway Service CRUD

### AWS Documentation (built-in proxy)
- `aws_knowledge_aws___search_documentation` — Search AWS docs, API references, blogs, and Well-Architected content
- `aws_knowledge_aws___read_documentation` — Fetch and read AWS documentation pages as markdown
- `aws_knowledge_aws___recommend` — Get related documentation recommendations

> Note: These documentation tools are redundant if you already have the `aws-knowledge` MCP server configured.

## When to use

- Containerizing web applications and generating Dockerfiles with AWS best practices
- Deploying applications end-to-end on ECS using Express Mode (auto-provisions ALB, VPC, IAM, auto-scaling)
- Building and pushing Docker images to ECR
- Diagnosing ECS deployment failures (CloudFormation, service events, task failures, network issues)
- Listing and inspecting ECS clusters, services, tasks, and task definitions
- Managing ECR repositories and container images
- Getting up-to-date ECS documentation and guidance on new features

## Caveats

- **Not recommended for production**: Tool is in active development; use only in dev/test/staging environments.
- **Read-only by default**: `ALLOW_WRITE=true` required for any create/update/delete operations.
- **Sensitive data gated**: Log and detailed resource access requires `ALLOW_SENSITIVE_DATA=true`.
- **Production caution**: Always keep both flags `false` when connected to production accounts to prevent accidental changes or data exposure.
- **Docker required**: `build_and_push_image_to_ecr` and `containerize_app` require Docker or Finch installed locally.
- **AWS credentials required**: Needs ECS, ECR, CloudFormation, and IAM permissions; see [EXAMPLE_IAM_POLICIES.md](https://github.com/awslabs/mcp/blob/main/src/ecs-mcp-server/EXAMPLE_IAM_POLICIES.md).
- **Built-in docs tools are duplicative** if `aws-knowledge` MCP server is already configured.

## Setup

Requires Python 3.10+, `uv`, Docker (or Finch), and configured AWS credentials.

### IAM Permissions

Use a dedicated IAM role with least-privilege. Minimum for read-only use:
- `ecs:List*`, `ecs:Describe*`
- `ecr:DescribeRepositories`, `ecr:ListImages`, `ecr:DescribeImages`
- `cloudformation:DescribeStacks`
- `cloudwatch:GetLogEvents`, `logs:StartQuery`, `logs:GetQueryResults`
- `elasticloadbalancing:Describe*`
- `ec2:Describe*`

Write operations additionally require: `ecs:Create*`, `ecs:Update*`, `ecs:Delete*`,
`ecr:CreateRepository`, `ecr:PutImage`, `iam:PassRole`, `cloudformation:*`.

See [EXAMPLE_IAM_POLICIES.md](https://github.com/awslabs/mcp/blob/main/src/ecs-mcp-server/EXAMPLE_IAM_POLICIES.md) for complete policy examples.

### Environment (optional)

Add to `~/.config/opencode/opencode.env` as needed:
```
AWS_PROFILE=your-profile-name
AWS_REGION=us-east-1
```

## opencode.jsonc config

```jsonc
"aws-ecs": {
  "type": "local",
  "command": ["uvx", "--from", "awslabs-ecs-mcp-server", "ecs-mcp-server"],
  "environment": {
    "AWS_PROFILE": "{env:AWS_PROFILE}",
    "AWS_REGION": "{env:AWS_REGION}",
    "FASTMCP_LOG_LEVEL": "ERROR",
    "ALLOW_WRITE": "false",
    "ALLOW_SENSITIVE_DATA": "false"
  }
}
```
