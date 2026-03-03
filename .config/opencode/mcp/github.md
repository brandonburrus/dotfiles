---
name: github
type: remote
url: "https://api.githubcopilot.com/mcp/"
requires_env:
  - GITHUB_TOKEN
---

## Description

The official GitHub MCP Server from GitHub. Provides comprehensive access to
GitHub repositories, issues, pull requests, code, actions, discussions, and
more. Hosted remotely by GitHub — no local binary or Docker required.

## Tools provided

Default toolsets enabled:

- **context** — Current user profile and GitHub context
- **repos** — Repository browsing, file contents, commits, branches, releases
- **issues** — Create, read, update, and search issues
- **pull_requests** — Create, review, and manage pull requests
- **users** — GitHub user profile lookups

Additional toolsets available (opt-in via `GITHUB_TOOLSETS` env var):

- **actions** — Workflow runs, jobs, logs, and triggers
- **code_security** — Code scanning and Dependabot alerts
- **discussions** — Repository and org discussions
- **gists** — GitHub Gists
- **git** — Low-level Git API operations
- **notifications** — GitHub notification management
- **orgs** — Organization management
- **projects** — GitHub Projects (v2)
- **labels** — Issue and PR labels
- **stargazers** — Repository stargazers
- **secret_protection** — Secret scanning alerts
- **security_advisories** — Security advisories
- **copilot** — Copilot coding agent and review tools

## When to use

- Searching GitHub for code examples, issues, or PRs
- Creating or reviewing pull requests from within OpenCode
- Fetching files or commit history from any accessible repository
- Monitoring GitHub Actions workflow runs and failures
- Automating GitHub workflows and triage

## Caveats

This server adds a significant number of tools to context. Consider enabling
it per-agent rather than globally if context size is a concern. Use the
`GITHUB_TOOLSETS` environment variable or toolset config to limit which tool
groups are active.

## Setup

Requires a GitHub Personal Access Token with `repo` scope (add `read:org` for
organization access).

1. Create a token at https://github.com/settings/tokens
2. Add to `~/.config/opencode/opencode.env`:

```
GITHUB_TOKEN=ghp_your_token_here
```

## opencode.jsonc config

```jsonc
"github": {
  "type": "remote",
  "url": "https://api.githubcopilot.com/mcp/",
  "headers": {
    "Authorization": "Bearer {env:GITHUB_TOKEN}"
  }
}
```
