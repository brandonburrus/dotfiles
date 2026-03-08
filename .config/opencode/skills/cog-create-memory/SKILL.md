---
name: cog-create-memory
description: Proactively capture useful information as long-term memories during any task — use when you discover user preferences, non-obvious solutions, reusable patterns and approaches, or decisions worth remembering across sessions. Saves automatically without prompting the user.
---

## What I do

Identify and store long-term memories using `cog_create-memory` when encountering
information during a task that would be valuable in a future session.

## When to use me

Load this skill when any of the following surface during a task:

- **User preferences** — coding style, tooling choices, communication style, how they
  like things structured or explained
- **Non-obvious solutions** — workarounds, gotchas, or fixes that took real effort to
  discover and would be worth knowing next time
- **Reusable patterns** — architectural approaches, strategies, naming conventions,
  or structural decisions that would apply across projects or sessions, not
  one-time project-specific facts
- **Corrections** — when the user corrects a mistake or clarifies a misunderstanding
  that reveals a preference or constraint worth internalizing
- **Environment specifics** — tooling versions, config quirks, or setup details that
  aren't documented and would save time to recall
- **Recurring decisions** — when the user makes a choice that is likely to come up
  again in future sessions

## When NOT to save

- Trivial, obvious, or well-documented facts
- Ephemeral context that only applies to the current task
- Secrets, credentials, API keys, or any sensitive personal data
- Information that has no plausible future relevance
- Project-specific facts that don't generalize (e.g., hardcoded repo names,
  org-specific config, one-time setup steps) — unless they encode a reusable
  workflow, strategy, or pattern that would apply in similar contexts

## Workflow

### 1. Identify the memory candidate

Extract the core insight: what was learned, decided, discovered, or clarified.

### 2. Compose the memory fields

- **name**: 3–6 words, snake_case or hyphenated (e.g. `user-prefers-tabs`,
  `auth-token-refresh-pattern`, `monorepo-build-order`)
- **description**: 2–3 sentences describing *when* this memory is relevant and
  *what* it contains — this is used for future semantic retrieval
- **content**: Full detail — include context, rationale, concrete examples, and any
  caveats or edge cases. More detail is better.
- **keywords**: A broad set of terms covering the topic, tools, patterns, and domain

### 3. Save

Call `cog_create-memory` immediately with the composed fields. Do not ask the user
for confirmation and do not announce the save.
