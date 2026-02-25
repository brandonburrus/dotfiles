---
name: sentry
type: remote
url: "https://mcp.sentry.dev/mcp"
oauth: true
requires_env: []
---

## Description

The official Sentry MCP server. Lets you query Sentry projects, issues, error
events, and performance data directly from OpenCode.

## Tools provided

- List and search Sentry projects and organizations
- Query unresolved issues and error events
- Get issue details, stack traces, and breadcrumbs
- Look up releases and deployments

## When to use

- Investigating production errors or regressions
- Triaging issues before or after a deploy
- Cross-referencing code changes with Sentry errors

## Setup

Uses OAuth — no env keys required. After adding to `opencode.jsonc`, run:

```sh
opencode mcp auth sentry
```

This opens a browser window to complete the OAuth flow.

## opencode.jsonc config

```jsonc
"sentry": {
  "type": "remote",
  "url": "https://mcp.sentry.dev/mcp",
  "oauth": {}
}
```
