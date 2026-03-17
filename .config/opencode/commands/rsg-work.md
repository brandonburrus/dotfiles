---
description: Start RSG work — fetch Rally story, plan implementation with user, execute, then commit and open a draft PR
---

You are starting a complete RSG work session. Follow the phases below in strict order. Do not skip phases or begin file modifications before the designated gate.

The user invoked this command with: **$ARGUMENTS**

Current directory: !`pwd`
Current git branch: !`git branch --show-current 2>/dev/null || echo "not in a git repo"`

---

## Phase 1 — Parse arguments

Parse `$ARGUMENTS`:

- The **first token** is the Rally artifact ID (e.g. `US123456`, `DE9876`).
- If the first argument is `#`, empty, or blank, stop immediately and respond:
  > "Please provide a Rally artifact ID as the first argument.
  > Examples: `/rsg-work US123456` or `/rsg-work DE9876 optional notes here`"
  Then stop — do not continue to Phase 2.
- Everything after the first token is treated as **optional notes** from the user. Retain these — they will inform the clarification questions and implementation plan.

---

## Phase 2 — Check for an existing plan

Before fetching anything from Rally, check for a pre-existing plan file:

```bash
ls ~/.agents/plans/rsg/<artifact-id>-plan.md 2>/dev/null
```

- **If a plan file exists**, read it and present a summary to the user. Ask:
  > "I found an existing plan for `<artifact-id>` at `~/.agents/plans/rsg/<artifact-id>-plan.md`. Would you like to:
  > 1. Resume from this plan (skip straight to execution)
  > 2. Use it as a starting point and refine it
  > 3. Start fresh (ignore the existing plan)"

  Wait for the user's choice before continuing.

- **If no plan file exists**, continue to Phase 3.

---

## Phase 3 — Fetch the Rally artifact

Determine the artifact type from the ID prefix:

- `US######` → run `dops rally story get <id> --summary --ac --tasks`
- `DE######` → run `dops rally defect get <id> --all`
- Unknown or ambiguous prefix → run `dops rally lookup <id>` first to determine the type, then fetch with the appropriate command above

If the `dops` CLI is unavailable or the artifact cannot be found, tell the user and ask them to provide the following manually before continuing:
- Story/defect name
- Description
- Acceptance criteria

Retain and clearly note the following from the response:
- **Name** and **description**
- **Acceptance criteria** (these are the primary driver of the plan structure)
- **Existing task list** (if any — these may hint at intended implementation approach)
- **Notes field** (if populated)

---

## Phase 4 — Clarification loop

After reviewing the Rally artifact, carefully identify every aspect of the work that is **ambiguous, underspecified, or unclear**. Consider all of the following dimensions:

- **Scope** — which systems, services, or layers are affected?
- **Behavior** — exact expected inputs, outputs, and edge cases for any changed functionality?
- **Data** — schema changes? migrations? backward compatibility requirements?
- **Integrations** — are external services, APIs, or other teams involved?
- **UI/UX** — if frontend work is involved, are designs or specs available?
- **Testing** — what level of test coverage is expected? unit, integration, e2e?
- **Non-goals** — what is explicitly out of scope for this story?
- **Definition of done** — beyond the ACs, are there additional expectations (docs, feature flags, etc.)?

**Rules for this phase:**
- Compile all questions and ask them in a **single batched message** — do not ask one at a time
- Clearly separate what is well understood from what needs clarification
- **Never assume an answer** — if something could reasonably go multiple ways, it must be asked
- **Gate:** do not proceed to Phase 5 until every open question has a clear answer from the user
- If the user's answers introduce new ambiguities, ask follow-up questions and repeat until no open questions remain

---

## Phase 5 — Discover and confirm repos in scope

**Step 5a — Detect context:**

Check whether the current directory is inside a git repo:

```bash
git rev-parse --is-inside-work-tree 2>/dev/null
```

- **If yes (inside a repo):** Note this as a candidate repo. Also scan the parent directory for sibling repos by looking for directories containing a `.git` folder.
- **If no (in a parent directory):** Scan child directories for those containing a `.git` folder.

**Step 5b — Present and confirm:**

List all candidate repos found and ask the user:
> "I found the following repos. Which are in scope for this story? (select all that apply)"

Wait for the user's response before continuing. Work only with the confirmed repos from this point forward.

---

## Phase 6 — Check for existing branches

For each confirmed repo, check whether a branch already exists for this artifact:

```bash
git branch -a | grep -i "<artifact-id>"
```

- **If one or more branches are found**, list them and ask:
  > "I found existing branch(es) for `<artifact-id>` in `<repo>`:
  > - `<branch-name>` (local/remote)
  >
  > Would you like to:
  > 1. Continue on an existing branch (I'll review what's already been done)
  > 2. Start fresh on a new branch"

  If the user chooses to continue on an existing branch, check it out and run `git log --oneline -10` and `git diff main...HEAD --stat` (or appropriate base branch) to summarize what work has already been completed. Factor this into the implementation plan — do not re-do work that is already done.

- **If no branches are found**, continue to Phase 7.

---

## Phase 7 — Verify repo state and sync

For each confirmed repo:

**7a — Check for uncommitted changes:**
```bash
git status --short
```

If there are uncommitted changes, ask the user:
> "Repo `<name>` has uncommitted changes. Would you like to stash them before we start, or leave them as-is?
> - Stash: I'll run `git stash push -m 'rsg-work stash before <artifact-id>'`
> - Leave: We'll continue with the working tree as-is (note: this may complicate branching)"

Apply the user's choice before continuing.

**7b — Check if behind remote:**
```bash
git fetch && git status -sb
```

If the branch is behind its remote, ask the user:
> "Repo `<name>` is behind its remote by `<n>` commit(s). Would you like to pull before we start?"

Apply the user's choice before continuing.

---

## Phase 8 — Explore the codebase(s)

For each confirmed repo:

1. Get the high-level structure — scan the root and key subdirectories (e.g. `src/`, `app/`, `packages/`, `lib/`, `services/`)
2. Identify code, tests, and configs relevant to the story's domain using the artifact description and your clarified understanding from Phase 4
3. Look for existing patterns to follow (naming conventions, architectural patterns, test style)
4. Note the tech stack, frameworks, and any relevant tooling (linter config, test runner, CI setup)

Carry this context into the implementation plan.

---

## Phase 9 — Build and present the implementation plan

Using everything gathered — the Rally artifact, clarification answers, optional notes, existing branch work, and codebase exploration — create a structured implementation plan.

**Format: numbered phases, each tied to acceptance criteria**

```
## Implementation Plan — <artifact-id>: <Story Name>

### Phase 1 — <Descriptive Name>
> Addresses AC: "<acceptance criterion text>"

- [ ] `path/to/file.ts` — description of what changes and why
- [ ] `path/to/other.ts` — description of what changes and why
- [ ] `path/to/test.spec.ts` — description of test coverage to add

### Phase 2 — <Descriptive Name>
> Addresses AC: "<acceptance criterion text>"

- [ ] ...
```

Guidelines:
- Every acceptance criterion must be addressed by at least one phase
- If an existing branch already completes some phases, mark them `[x]` and note they are already done
- Incorporate the user's optional notes where relevant
- Be specific about files — use actual paths where known, or describe the expected location if not yet determined
- Include test coverage as explicit tasks, not an afterthought

Present the plan and ask:
> "Does this plan look right, or would you like to adjust anything before we start?"

---

## Phase 10 — Refine plan (loop)

Work with the user to adjust the plan. Accept changes, additions, removals, or reorderings. Re-present the updated plan after each revision.

**Gate: do not begin any file modifications until the user explicitly approves the plan.**

**After the user approves**, immediately save the plan to disk:

```bash
mkdir -p ~/.agents/plans/rsg
```

Save the full plan markdown to: `~/.agents/plans/rsg/<artifact-id>-plan.md`

Confirm to the user that the plan has been saved, then proceed.

> **Resumability note:** If this session is interrupted, the plan has been saved to `~/.agents/plans/rsg/<artifact-id>-plan.md`. Resume by running `/rsg-work <artifact-id>` — the saved plan will be detected automatically in Phase 2.

---

## Phase 11 — Execute the plan

With the approved plan in hand, implement the changes phase by phase:

- Work through each phase in order
- Check off tasks as they are completed (`[ ]` → `[x]`)
- After completing each phase, briefly confirm to the user what was done before moving to the next
- If you encounter anything unexpected — a missing dependency, an ambiguous requirement, a pattern that doesn't fit — **stop and ask the user** before continuing. Never make assumptions during execution.

---

## Phase 12 — Verify the implementation

Before presenting the implementation to the user for review, run automated checks for each affected repo.

**Linting and type-checking** — detect and run whatever is configured:
```bash
# Examples — use whatever applies to this repo
npm run lint
npm run typecheck
npx tsc --noEmit
```

**Tests** — run the test suite, prioritizing tests related to changed files:
```bash
# Examples — use whatever applies to this repo
npm test
npm run test:unit
npx jest --testPathPattern="<changed-file-pattern>"
```

If any checks fail:
- Attempt to fix the failures
- Re-run the checks to confirm they pass
- If a failure cannot be resolved automatically, describe the issue to the user and ask how to proceed

Do not present the implementation as complete until all checks pass (or the user explicitly accepts known failures).

---

## Phase 13 — Present completed implementation

Once all checks pass, summarize the completed implementation:

- **Files changed/created:** list every file with a one-line description of what changed
- **Deviations from plan:** note anything that was done differently than planned and why
- **Manual verification:** highlight anything the user should check locally (e.g. run the app, test a specific flow, review a visual change)
- **Test results:** confirm all tests and lint checks passed

Then say:
> "Implementation is complete. Please review the changes. When you're satisfied, let me know and I'll create the commits and open a draft PR."

**Gate: do not create any commits or PRs until the user explicitly approves.**

---

## Phase 14 — Commit and open draft PR(s)

Only proceed here after the user has explicitly confirmed they are satisfied with the implementation.

**Step 14a — Branch and commit (per repo):**

Load the `rsg-branching-commiting` skill and follow its full workflow for each affected repo. This covers:
- Creating a correctly named branch (or confirming we are already on one from Phase 6)
- Staging and committing all changes with properly prefixed commit messages

**Step 14b — PR ordering (multi-repo only):**

If changes span multiple repos, ask the user:
> "These repos all have changes: `<list>`. What order should the PRs be created and merged? (e.g. shared library before consumers)"

Note any cross-repo dependencies explicitly in each PR description.

**Step 14c — Create draft PRs:**

Load the `rsg-pull-request` skill and follow its full workflow for each repo. All PRs must be created as **drafts**.

After each PR is created, display its URL to the user.
