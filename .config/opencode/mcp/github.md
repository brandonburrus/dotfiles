---
name: github
type: local
command: ["npx", "-y", "@modelcontextprotocol/server-github"]
requires_env:
  - GITHUB_TOKEN
env:
  GITHUB_PERSONAL_ACCESS_TOKEN: "{env:GITHUB_TOKEN}"
---

## Description

The official GitHub MCP server from Anthropic/ModelContextProtocol. Provides
comprehensive access to GitHub repositories, issues, pull requests, and more.

## Tools provided

- Search repositories, issues, PRs, and code
- Read file contents and directory trees
- Create and update issues and pull requests
- Get commit history, diffs, and blame
- Manage branches and releases

## When to use

- Searching GitHub for code examples or open issues
- Creating or reviewing pull requests from within OpenCode
- Fetching files from other repositories
- Automating GitHub workflows

## Caveats

This server adds a significant number of tools to context. Consider enabling
it per-agent rather than globally if context size is a concern.

## Setup

Requires a GitHub Personal Access Token with `repo` scope (and `read:org` for
organization access).

1. Create a token at https://github.com/settings/tokens
2. Add to `~/.config/opencode/opencode.env`:

```
GITHUB_TOKEN=ghp_your_token_here
```

## opencode.jsonc config

```jsonc
"github": {
  "type": "local",
  "command": ["npx", "-y", "@modelcontextprotocol/server-github"],
  "environment": {
    "GITHUB_PERSONAL_ACCESS_TOKEN": "{env:GITHUB_TOKEN}"
  }
}
```
