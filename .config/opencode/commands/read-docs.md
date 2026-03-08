---
description: Find and load relevant tech documentation into context (e.g. /read-docs react hooks)
---

The user wants to read documentation about: **$ARGUMENTS**

**Step 1 — Validate.**
If `$ARGUMENTS` is empty or blank, respond:
> "Please provide a technology and optional topic. Examples:
> - `/read-docs react hooks`
> - `/read-docs typescript generics`
> - `/read-docs tailwind flexbox`
> - `/read-docs python asyncio`"
Then stop.

**Step 2 — Resolve the best docs URL.**
Using your knowledge, identify the most relevant official documentation page for `$ARGUMENTS`.
- Prefer the specific section/page over a landing page when the topic is clear (e.g. the React Hooks reference page, not just react.dev)
- If you're uncertain, pick your best guess and proceed — note it was a best guess in your response

**Step 3 — Fetch the docs.**
Use the `webfetch` tool to retrieve the URL in markdown format.

**Step 4 — Confirm.**
Reply with a single line: the URL that was fetched (and whether it was a best guess). No summary, no extra output.
