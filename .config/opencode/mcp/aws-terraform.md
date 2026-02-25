---
name: aws-terraform
type: local
command: ["uvx", "awslabs.terraform-mcp-server@latest"]
requires_env: []
optional_env:
  - FASTMCP_LOG_LEVEL
  - AWS_PROFILE
  - AWS_REGION
env:
  FASTMCP_LOG_LEVEL: "ERROR"
---

## Description

MCP server for Terraform on AWS. Provides prescriptive Terraform best practices,
AWS Well-Architected guidance, security compliance scanning via Checkov, AWS/AWSCC
provider documentation lookup, Terraform Registry module analysis, and direct
Terraform and Terragrunt workflow execution (init, plan, validate, apply, destroy).

## Tools provided

- **terraform://workflow_guide** (resource) — Security-focused development workflow guide
- **terraform://aws_best_practices** (resource) — AWS-specific Terraform guidance
- **terraform://aws_provider_resources_listing** (resource) — AWS provider resource list
- **terraform://awscc_provider_resources_listing** (resource) — AWSCC provider resource list
- **SearchAwsProviderDocs** — Search AWS and AWSCC provider documentation for resources and attributes
- **SearchAwsIaModules** — Search AWS-IA GenAI modules (Bedrock, OpenSearch Serverless, SageMaker, Streamlit)
- **SearchTerraformRegistry** — Search and analyze Terraform Registry modules by URL or identifier
- **RunCheckovScan** — Run Checkov security/compliance scans on Terraform code and get remediation guidance
- **ExecuteTerraformCommand** — Run Terraform commands (init, plan, validate, apply, destroy) with variables and region
- **ExecuteTerragruntCommand** — Run Terragrunt commands (init, plan, validate, apply, run-all, destroy) with config flags

## When to use

- Writing or reviewing Terraform configurations for AWS infrastructure
- Looking up AWS or AWSCC provider resource documentation and examples
- Running security scans on Terraform code before deployment
- Executing Terraform/Terragrunt workflows (plan, apply, destroy) from an agentic session
- Finding and analyzing Terraform Registry modules
- Getting AWS Well-Architected guidance for IaC patterns
- Working with AI/ML infrastructure (Bedrock, SageMaker) using aws-ia modules

## Caveats

- Requires `uv` and Python 3.10+ installed locally.
- Requires Terraform CLI installed for workflow execution tools.
- Requires Checkov installed for `RunCheckovScan`.
- Prefers AWSCC provider over AWS provider for consistent API behavior and better security defaults.
- Terraform apply/destroy operations make real infrastructure changes — review plans carefully before approving.
- On Windows, use `uv tool run` invocation instead of `uvx` (see upstream docs for Windows config).
- Security scanning does not replace a manual infrastructure review before production deployments.

## Setup

No API keys required for documentation and best-practices features. For workflow
execution tools that interact with AWS, valid AWS credentials must be available in
the environment.

**Prerequisites:**
1. Install `uv`: https://docs.astral.sh/uv/getting-started/installation/
2. Install Python 3.10+: `uv python install 3.10`
3. Install Terraform CLI: https://developer.hashicorp.com/terraform/install
4. Install Checkov: `pip install checkov`

To use a specific AWS profile or region for workflow execution, add to
`~/.config/opencode/opencode.env`:
```
AWS_PROFILE=your-aws-profile
AWS_REGION=us-east-1
```

## opencode.jsonc config

```jsonc
"aws-terraform": {
  "type": "local",
  "command": ["uvx", "awslabs.terraform-mcp-server@latest"],
  "environment": {
    "FASTMCP_LOG_LEVEL": "ERROR"
  }
}
```
