---
name: cog-recollect
description: Search long-term memory for context relevant to the current task — use this liberally at the start of tasks, when encountering unfamiliar patterns, or whenever past sessions might hold useful context; always ask the user before loading full memory content. If no memories are relevant, continue without them.
---

## What I do

Search long-term memory for relevant context and selectively surface it into
the current session via `cog_search-memory` and `cog_retrieve-memory`.

## When to use me

Load this skill liberally — err on the side of searching. Good triggers:
- Starting a new task, feature, or investigation
- Encountering a pattern, tool, or codebase that might have been worked on before
- A user references something from a past session ("like we did before", "remember when...")
- A decision needs to be made where past preferences or rationale might apply
- Debugging something that feels like it may have been encountered previously

## Workflow

### 1. Formulate a query

Based on the current task or context, construct a focused natural-language search
query that captures the key concepts (tools, patterns, decisions, domain).

### 2. Search

Call `cog_search-memory` with the query. Use a `topK` of 5 unless the topic is
broad, in which case use up to 10.

### 3. Present results

Display results as a numbered list. For each, show:
- **Name**
- **Description**
- **Score** (as a percentage, e.g. 87%)

If no results are returned, tell the user no relevant memories were found and
continue without them.

### 4. Ask before loading

Always ask the user before retrieving full memory content — loading memories
consumes context and should be intentional:

> "Would you like me to load the full content of any of these? (reply with number(s) or name(s), or 'none')"

Do not load any memory without explicit user confirmation.

### 5. Retrieve and inject

For each memory the user approves, call `cog_retrieve-memory` with its name.
Display the full content clearly under the memory name, then continue the
original task with that context in mind.
