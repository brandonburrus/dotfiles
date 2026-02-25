---
name: aws-cfn
type: local
command: ["uvx", "awslabs.cfn-mcp-server@latest"]
requires_env: []
optional_env:
  - AWS_PROFILE
  - AWS_ACCESS_KEY_ID
  - AWS_SECRET_ACCESS_KEY
  - AWS_SESSION_TOKEN
  - AWS_DEFAULT_REGION
  - FASTMCP_LOG_LEVEL
env:
  AWS_PROFILE: "{env:AWS_PROFILE}"
---

## Description

MCP server that enables LLMs to create and manage over 1,100 AWS resources through natural
language using AWS Cloud Control API and IaC Generator. Supports full CRUD operations on
any resource type supported by the Cloud Control API, plus CloudFormation template
generation from existing resources.

## Tools provided

| Tool | Description |
|------|-------------|
| `create_resource` | Creates an AWS resource declaratively via Cloud Control API |
| `get_resource` | Reads all properties/attributes of a specific AWS resource |
| `update_resource` | Applies changes to an existing AWS resource declaratively |
| `delete_resource` | Safely removes an AWS resource with validation |
| `list_resources` | Enumerates all resources of a specified type in your AWS environment |
| `get_resource_schema_information` | Returns the CloudFormation schema for a resource type |
| `get_request_status` | Checks the status of an in-flight create/update/delete operation |
| `create_template` | Generates a CloudFormation template from created or listed resources |

## When to use

- Provisioning or modifying AWS infrastructure via natural language
- Querying live resource state across your AWS environment
- Generating CloudFormation templates from existing resources
- Exploring what properties a resource type supports before creating it
- Managing resources in accounts where only Cloud Control API permissions are available

## Caveats

- Only covers resource types supported by [AWS Cloud Control API](https://docs.aws.amazon.com/cloudcontrolapi/latest/userguide/supported-resources.html)
- Generated templates are designed for importing existing resources into a stack, not
  necessarily for creating identical resources in a new account/region
- Some resource types don't support all CRUD operations
- Rate limiting may affect bulk operations
- Requires Cloud Control API and/or IaC Generator availability in the target region
- Pass `--readonly` as an extra arg to restrict the server to read-only operations

## Setup

Configure AWS credentials using one of:
1. **AWS CLI profile**: `aws configure` (recommended)
2. **Environment variables**: set `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`,
   `AWS_DEFAULT_REGION` (and optionally `AWS_SESSION_TOKEN` for temporary credentials)

Minimum required IAM permissions:
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "cloudcontrol:ListResources",
        "cloudcontrol:GetResource",
        "cloudcontrol:CreateResource",
        "cloudcontrol:DeleteResource",
        "cloudcontrol:UpdateResource",
        "cloudformation:CreateGeneratedTemplate",
        "cloudformation:DescribeGeneratedTemplate",
        "cloudformation:GetGeneratedTemplate"
      ],
      "Resource": "*"
    }
  ]
}
```

Add to `~/.config/opencode/opencode.env` if using environment-variable credentials:
```
AWS_PROFILE=your-named-profile
# or
AWS_ACCESS_KEY_ID=...
AWS_SECRET_ACCESS_KEY=...
AWS_DEFAULT_REGION=us-east-1
```

## opencode.jsonc config

```jsonc
"aws-cfn": {
  "type": "local",
  "command": ["uvx", "awslabs.cfn-mcp-server@latest"],
  "environment": {
    "AWS_PROFILE": "{env:AWS_PROFILE}"
  }
}
```

For read-only mode, add `"--readonly"` to the command array:
```jsonc
"aws-cfn": {
  "type": "local",
  "command": ["uvx", "awslabs.cfn-mcp-server@latest", "--readonly"],
  "environment": {
    "AWS_PROFILE": "{env:AWS_PROFILE}"
  }
}
```
