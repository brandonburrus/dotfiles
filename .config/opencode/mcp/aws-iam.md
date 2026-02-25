---
name: aws-iam
type: local
command: ["uvx", "awslabs.iam-mcp-server@latest"]
requires_env: []
optional_env:
  - AWS_PROFILE
  - AWS_REGION
  - AWS_ACCESS_KEY_ID
  - AWS_SECRET_ACCESS_KEY
  - FASTMCP_LOG_LEVEL
env:
  AWS_PROFILE: "{env:AWS_PROFILE}"
  AWS_REGION: "{env:AWS_REGION}"
  FASTMCP_LOG_LEVEL: "{env:FASTMCP_LOG_LEVEL}"
---

## Description

MCP server for comprehensive AWS Identity and Access Management (IAM) operations. Provides AI assistants with the ability to manage IAM users, roles, groups, policies, and permissions while following security best practices. Supports a read-only mode to prevent accidental modifications.

## Tools provided

- `list_users` — List IAM users with optional path prefix filtering
- `get_user` — Get detailed info about a user including attached policies, groups, and access keys
- `create_user` — Create a new IAM user (with optional path and permissions boundary)
- `delete_user` — Delete an IAM user, optionally force-removing all associated resources
- `list_roles` — List IAM roles with optional path prefix filtering
- `create_role` — Create a new IAM role with a trust policy document
- `list_groups` — List IAM groups with optional path prefix filtering
- `get_group` — Get group details including members, attached policies, and inline policies
- `create_group` — Create a new IAM group
- `delete_group` — Delete an IAM group, optionally force-removing members and policies
- `add_user_to_group` — Add a user to an IAM group
- `remove_user_from_group` — Remove a user from an IAM group
- `attach_group_policy` — Attach a managed policy to a group
- `detach_group_policy` — Detach a managed policy from a group
- `list_policies` — List IAM policies (scope: All, AWS, or Local)
- `attach_user_policy` — Attach a managed policy to a user
- `detach_user_policy` — Detach a managed policy from a user
- `attach_role_policy` — Attach a managed policy to a role
- `detach_role_policy` — Detach a managed policy from a role
- `create_access_key` — Create a new access key for a user
- `delete_access_key` — Delete an access key for a user
- `simulate_principal_policy` — Simulate IAM policy evaluation to test permissions before applying
- `put_user_policy` / `get_user_policy` / `delete_user_policy` / `list_user_policies` — CRUD for user inline policies
- `put_role_policy` / `get_role_policy` / `delete_role_policy` / `list_role_policies` — CRUD for role inline policies

## When to use

- Auditing or exploring IAM users, roles, groups, and policies in an AWS account
- Creating or modifying IAM identities and permissions as part of infrastructure setup
- Testing whether a principal has specific permissions via policy simulation before deployment
- Managing access keys for IAM users programmatically
- Enforcing least-privilege by reviewing and adjusting attached/inline policies

## Caveats

- Requires AWS credentials with broad IAM permissions (see docs for the full required policy)
- `create_access_key` returns the secret key only once — it cannot be retrieved again
- Use `--readonly` flag in the command args to prevent all mutating operations in sensitive environments
- Operations like `delete_user` and `delete_group` with `force=true` are irreversible

## Setup

1. Install `uv` if not already available: `curl -LsSf https://astral.sh/uv/install.sh | sh`
2. Ensure AWS credentials are configured via `~/.aws/credentials`, `AWS_PROFILE`, or environment variables
3. The IAM principal used must have the permissions listed in the [Required IAM Permissions](https://awslabs.github.io/mcp/servers/iam-mcp-server#required-iam-permissions) section
4. Add the server config below to your `opencode.jsonc`

For read-only mode, add `"--readonly"` to the `command` array:
```jsonc
"command": ["uvx", "awslabs.iam-mcp-server@latest", "--readonly"]
```

## opencode.jsonc config

```jsonc
"aws-iam": {
  "type": "local",
  "command": ["uvx", "awslabs.iam-mcp-server@latest"],
  "env": {
    "AWS_PROFILE": "your-aws-profile",
    "AWS_REGION": "us-east-1",
    "FASTMCP_LOG_LEVEL": "ERROR"
  }
}
```
