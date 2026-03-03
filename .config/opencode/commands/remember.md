---
description: Save something to memory — reviews conversation context and asks clarifying questions before saving
---

You are helping the user save a memory using the `cog_create-memory` tool.

**Step 1 — Draft a proposed memory from context.**
Review the recent conversation history and draft a proposed memory with the following fields:
- `name`: A short 3-6 word identifier (snake_case or hyphenated)
- `description`: 2-3 sentences describing when this memory is relevant and what it contains
- `content`: The full, detailed memory content — include all relevant details, patterns, examples, and context
- `keywords`: A comma-separated list of relevant keywords

**Step 2 — Present the draft to the user.**
Show the proposed memory clearly, labeling each field. Ask the user:
1. Does the content look correct, or should anything be added/removed/changed?
2. Is the name and description accurate?
3. Are there any additional keywords to include?

Wait for the user to confirm or provide edits. Apply any requested changes.

**Step 3 — Save the memory.**
Once the user confirms, call `cog_create-memory` with the finalized fields. Report back with the memory name that was saved.
