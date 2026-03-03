---
name: cog-memorize
description: Save something worth remembering to long-term memory — use this when a useful pattern, solution, user preference, architectural decision, or reusable insight has emerged from the conversation that would be valuable in future sessions
---

## What I do

Guide the process of distilling something valuable from the current conversation
into a well-formed memory entry and saving it via `cog_create-memory`.

## When to use me

Load this skill when:
- A non-obvious solution or workaround was found that might recur
- A user preference or working style has been made explicit
- An architectural or design decision was made with meaningful rationale
- A pattern, convention, or project-specific rule was established
- Something took significant effort to figure out and shouldn't need rediscovering

## Workflow

### 1. Draft a proposed memory

Review the conversation and draft a memory with these fields:

- **name**: Short 3-6 word identifier (lowercase, hyphenated, e.g. `prefer-pnpm-over-npm`)
- **description**: 2-3 sentences describing what this memory contains and when it's relevant to retrieve it
- **content**: Full, detailed content — include context, rationale, examples, caveats, and any other details needed to make the memory actionable without re-reading the original conversation
- **keywords**: Comprehensive comma-separated list covering all relevant topics, tools, patterns, and themes

### 2. Present the draft to the user

Show the proposed memory with each field clearly labeled. Ask:
1. Does the content look correct? Anything to add, remove, or change?
2. Is the name descriptive enough?
3. Any additional keywords?

Wait for confirmation or edits. Apply any changes before saving.

### 3. Save

Call `cog_create-memory` with the finalized fields. Confirm to the user with the saved memory name.
