---
name: aws-bedrock-custom-model-import
type: local
command: ["uvx", "awslabs.aws-bedrock-custom-model-import-mcp-server@latest", "--allow-write"]
requires_env:
  - BEDROCK_MODEL_IMPORT_S3_BUCKET
optional_env:
  - AWS_PROFILE
  - AWS_REGION
  - AWS_ACCESS_KEY_ID
  - AWS_SECRET_ACCESS_KEY
  - AWS_SESSION_TOKEN
  - BEDROCK_MODEL_IMPORT_ROLE_ARN
  - FASTMCP_LOG_LEVEL
env:
  AWS_PROFILE: "{env:AWS_PROFILE}"
  AWS_REGION: "{env:AWS_REGION}"
  BEDROCK_MODEL_IMPORT_S3_BUCKET: "{env:BEDROCK_MODEL_IMPORT_S3_BUCKET}"
  BEDROCK_MODEL_IMPORT_ROLE_ARN: "{env:BEDROCK_MODEL_IMPORT_ROLE_ARN}"
  FASTMCP_LOG_LEVEL: "ERROR"
---

## Description

MCP server that streamlines importing custom models into Amazon Bedrock. Provides
tools for creating and monitoring model import jobs, and for listing, inspecting,
and deleting imported models. Automatically searches a configured S3 bucket for
model artifacts by model name when `BEDROCK_MODEL_IMPORT_S3_BUCKET` is set.

## Tools provided

- **create_model_import_job** — Create a new model import job. Supports custom
  IAM role ARN, S3 data source URI, VPC configuration, KMS key, resource tags,
  and an idempotency token.
- **list_model_import_jobs** — List existing import jobs, filterable by creation
  time range, status (`InProgress`, `Completed`, `Failed`), and name substring;
  sortable by `CreationTime` in ascending or descending order.
- **list_imported_models** — List successfully imported models with the same
  filtering and sorting options as `list_model_import_jobs`.
- **get_model_import_job** — Get detailed status and configuration for a specific
  import job by name or ARN.
- **get_imported_model** — Get details about a specific imported model by name or
  ARN.
- **delete_imported_model** — Delete an imported model from Amazon Bedrock by name
  or ARN.

## When to use

- Importing custom or fine-tuned models (e.g., Llama variants) into Amazon Bedrock
  from S3 artifacts
- Monitoring the progress of in-flight model import jobs
- Auditing or cleaning up imported models in a Bedrock account
- Automating model lifecycle management as part of an MLOps workflow

## Caveats

- `BEDROCK_MODEL_IMPORT_S3_BUCKET` is effectively required; without it, callers
  must supply an explicit S3 URI on every `create_model_import_job` call.
- The IAM role used (via `AWS_PROFILE` or explicit credentials) must include the
  `iam:PassRole` permission in addition to Bedrock model-import permissions when
  using API key authentication.
- The server runs with `--allow-write` by default (needed for import job
  creation). Remove the flag to enforce read-only mode.
- Requires `uv` and Python 3.12+ installed locally.
- Custom model import is not available in all AWS regions; verify availability
  before configuring a non-default region.

## Setup

**Prerequisites:**
1. Install `uv`: https://docs.astral.sh/uv/getting-started/installation/
2. Install Python 3.12+: `uv python install 3.12`
3. Install the AWS CLI and configure credentials: `aws configure`
4. Enable Amazon Bedrock in your AWS account and ensure the calling identity has
   permissions for `bedrock:CreateModelImportJob`, `bedrock:GetModelImportJob`,
   `bedrock:ListModelImportJobs`, `bedrock:ListImportedModels`,
   `bedrock:GetImportedModel`, `bedrock:DeleteImportedModel`, and
   `iam:PassRole`.
5. Create (or identify) an S3 bucket containing your model artifacts and set
   `BEDROCK_MODEL_IMPORT_S3_BUCKET` to that bucket name.
6. Optionally create a dedicated IAM execution role for import jobs and set
   `BEDROCK_MODEL_IMPORT_ROLE_ARN` to its ARN.

Set `AWS_PROFILE`, `AWS_REGION`, `BEDROCK_MODEL_IMPORT_S3_BUCKET`, and
`BEDROCK_MODEL_IMPORT_ROLE_ARN` in your environment or directly in the config
block below.

## opencode.jsonc config

```jsonc
"aws-bedrock-custom-model-import": {
  "type": "local",
  "command": [
    "uvx",
    "awslabs.aws-bedrock-custom-model-import-mcp-server@latest",
    "--allow-write"
  ],
  "environment": {
    "AWS_PROFILE": "default",
    "AWS_REGION": "us-east-1",
    "BEDROCK_MODEL_IMPORT_S3_BUCKET": "your-model-bucket",
    "BEDROCK_MODEL_IMPORT_ROLE_ARN": "arn:aws:iam::123456789012:role/your-import-role",
    "FASTMCP_LOG_LEVEL": "ERROR"
  }
}
```
