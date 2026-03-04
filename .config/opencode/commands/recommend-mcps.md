---
description: Recommend MCP servers for the current project using semantic search
subtask: true
---

Analyze the current project and recommend relevant MCP servers from the local
catalog. Follow these steps exactly:

## Step 1 — Read project files

Use the Read tool to read whichever of these files exist at the project root:
`README.md`, `README.mdx`, `package.json`, `Cargo.toml`, `pyproject.toml`,
`go.mod`, `composer.json`, `Gemfile`. Also note the presence of directories
like `.github/` or config files like `sentry.properties`.

## Step 2 — Identify primary technologies

From what you read, derive a concise list of **primary technologies** —
languages, frameworks, platforms, databases, and external services the project
uses. For example: `["TypeScript", "React", "GitHub Actions", "PostgreSQL"]`.

## Step 3 — Search the catalog

Call the `search_mcp` tool once with the technology array you identified.

## Step 4 — Filter already-installed servers

Read `.opencode/opencode.jsonc` (if it exists) to find which MCP servers are
already listed under `"mcp"`. Exclude those from your recommendations.

## Step 5 — Ask the user which ones to install

If no relevant servers were found (after filtering), tell the user.

Otherwise, present each recommendation clearly — name, match score, and a
one-line description — and **ask the user which ones they would like to
install**. Do not install anything until the user explicitly confirms. List the
options and wait for their response.

## Step 6 — Install confirmed servers

For each server the user approves, run `/install-mcp <name>`.
