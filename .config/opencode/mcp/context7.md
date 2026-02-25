---
name: context7
type: remote
url: "https://mcp.context7.com/mcp"
requires_env: []
optional_env:
  - CONTEXT7_API_KEY
---

## Description

Context7 by Upstash. Searches up-to-date documentation for libraries and
frameworks directly from their official sources. Eliminates hallucinated API
usage by grounding responses in real, current docs.

## Tools provided

- `resolve-library-id` — find the Context7 library ID for a package name
- `get-library-docs` — fetch current documentation for a library/version

## When to use

- Working with a library or framework and need accurate, current API docs
- Getting examples for a specific library feature (e.g. Zod, React, Prisma)
- Avoiding outdated or hallucinated API usage

## Setup

No API key required for basic usage (rate-limited). For higher rate limits,
sign up at https://context7.com and add your key:

Add to `~/.config/opencode/opencode.env`:
```
CONTEXT7_API_KEY=your_key_here
```

## opencode.jsonc config

Without API key:
```jsonc
"context7": {
  "type": "remote",
  "url": "https://mcp.context7.com/mcp"
}
```

With API key:
```jsonc
"context7": {
  "type": "remote",
  "url": "https://mcp.context7.com/mcp",
  "headers": {
    "CONTEXT7_API_KEY": "{env:CONTEXT7_API_KEY}"
  }
}
```
