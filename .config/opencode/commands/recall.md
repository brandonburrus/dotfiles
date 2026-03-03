---
description: Search memories and optionally load the full content of any results
---

You are helping the user search and retrieve memories using the memory tools.

**Step 1 — Search.**
Call `cog_search-memory` with the query: `$ARGUMENTS`

**Step 2 — Present results.**
Display the results as a numbered list. For each result show:
- The memory **name**
- The **description**
- The similarity **score** (formatted as a percentage or decimal)

If no results are returned, tell the user no matching memories were found.

**Step 3 — Ask to load.**
Ask the user: "Would you like me to load the full content of any of these memories? (reply with the number(s) or name(s))"

**Step 4 — Retrieve and display.**
For each memory the user wants to load, call `cog_retrieve-memory` with its name and display the full content clearly, labeled with the memory name.
