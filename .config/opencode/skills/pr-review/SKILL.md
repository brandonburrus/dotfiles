---
name: pr-review
description: Review a GitHub pull request — checks out the branch, delegates to language-specific reviewer subagents based on changed files, compiles and deduplicates issues, presents them for validation, and optionally posts a review on the PR. Supports RSG/RepublicServicesRepository Rally integration and maintains a persistent review history in ~/.reviews/.
---

## What I do

Orchestrate a full pull request review: resolve the repository, load previous review context, fetch PR details, handle the working tree, check out the PR branch, optionally fetch Rally acceptance criteria for RSG repos, delegate code analysis to appropriate language/domain-specific reviewer subagents, compile and deduplicate issues, present them for user validation, and optionally post inline comments and an overall review to GitHub. Maintains a persistent review record in `~/.reviews/` across sessions.

## When to use me

- The user provides a GitHub PR number and wants a structured code review
- The user provides a PR number and an optional repo name
- The user wants to continue or re-run a review started in a previous session

## Inputs

| Input | Required | Description |
|-------|----------|-------------|
| `pr`   | Yes | GitHub pull request number |
| `repo` | No  | Repository name (e.g. `my-repo`). Defaults to current directory's repo if omitted. |

---

## Workflow

### 1. Resolve the repository path and name

If `repo` is provided:
1. Check if the current directory is already that repo by running `git remote get-url origin` and checking if the URL contains the repo name.
2. If not, look for a directory matching the repo name in the parent directory (`ls ../`).
3. If found in the parent, note the absolute path and use it as the working directory for all subsequent commands.
4. If not found anywhere, ask the user to navigate to the repo directory and try again.

If `repo` is omitted, assume the current directory is the repo.

In either case, extract the **repo name** by running:
```bash
git remote get-url origin
```
Parse the repo name as the segment after the last `/` in the URL, stripping `.git`. This is used for review file naming and `gh` commands.

Also extract the **GitHub org/owner** from the same URL (the segment before the repo name after the host). If the owner is `RepublicServicesRepository`, this is an **RSG repo** — note this for step 6.

---

### 2. Check for an existing review file

Check whether `~/.reviews/REVIEW-<repo>-<pr>.md` exists.

**If it exists:**
- Read the file and extract from the most recent review section:
  - The date of the last review
  - All issues that were previously discovered
  - Which issues were validated and posted as comments
  - Which issues were dismissed
- Inform the user:
  > "Found a previous review from [date] with [N] issues discovered ([N] posted, [N] dismissed). I'll use this to flag recurring issues and avoid re-reporting already-addressed ones."
- Store this as `previous_review` in memory.
- **Important:** The review file is context for deduplication only. Always use the live PR and codebase as the source of truth.

**If it does not exist:**
- `previous_review` is empty — this is the first review of this PR.

---

### 3. Fetch PR details

Run in the repo directory:
```bash
gh pr view <pr> --json number,title,body,author,headRefName,baseRefName,additions,deletions,changedFiles,files,state,reviews,comments,reviewDecision,headRefOid
```

If using an explicit repo (not the current directory):
```bash
gh pr view <pr> --repo <owner>/<repo> --json number,title,body,author,headRefName,baseRefName,additions,deletions,changedFiles,files,state,reviews,comments,reviewDecision,headRefOid
```

Extract and store:
- PR title, body, author username
- Head branch name (`headRefName`), base branch (`baseRefName`)
- Head commit SHA (`headRefOid`) — needed for inline comments in step 11
- List of changed files with their paths
- All existing review comments (`reviews`) and PR comments (`comments`) — used in step 9 to avoid duplication

---

### 4. Check the working tree and stash if needed

Run in the repo directory:
```bash
git status --porcelain
```

**If output is empty:** working tree is clean — store the current branch and continue.

**If output is non-empty:** there are uncommitted changes. Ask the user:
> "The working tree has uncommitted changes. Would you like to stash them before checking out the PR branch? Choosing No will cancel the review."

- **Yes:** run `git stash push -m "pr-review: before reviewing PR #<pr>"` and store the stash was created.
- **No:** exit the review workflow entirely. Do not proceed.

Store the current branch with:
```bash
git branch --show-current
```
Store as `original_branch`.

---

### 5. Check out the PR branch

```bash
gh pr checkout <pr>
```

This fetches the PR's head branch from the remote and checks it out locally.

---

### 6. Fetch Rally context (RSG repos only)

If this is an RSG repo (owner is `RepublicServicesRepository`):

1. Parse the PR title for a Rally artifact ID using the pattern `(US|DE)\d+` (e.g. `US123456` or `DE789012`).
2. If found:
   - For `US######`: run `dops rally story get <id> --ac`
   - For `DE######`: run `dops rally defect get <id>`
   - Extract: artifact name, description, and acceptance criteria (stories only).
   - Store as `rally_context`.
3. If no artifact ID is found in the title, or if the `dops` command fails, skip Rally context and continue — do not block the review.

---

### 7. Analyze changed files and propose reviewers

Inspect the list of changed file paths from step 3. Apply the following mapping to determine which reviewer agents to propose:

| File pattern / signal | Reviewer(s) to propose |
|---|---|
| `*.py` | `python-reviewer` |
| `*.tf`, `*.tfvars`, `*.hcl` | `terraform-reviewer` |
| `*.sql` | `sql-reviewer` |
| `*.js`, `*.mjs`, `*.cjs` | `javascript-reviewer` |
| `*.ts` or `*.tsx` + `angular.json` present OR `@angular/core` in `package.json` | `angular-reviewer` |
| `*.ts` or `*.tsx` + `react` in `package.json` OR `from 'react'` in changed files | `react-reviewer` |
| `*.ts` or `*.tsx` + `solid-js` in `package.json` | `solidjs-reviewer` |
| `*.ts` or `*.tsx` + `aws-cdk-lib` or `@aws-cdk` in `package.json` | `aws-cdk-reviewer` |
| `*.ts` or `*.tsx` with no UI framework detected (server-side / generic) | `typescript-reviewer`, `node-reviewer` |
| Any remaining `*.ts` or `*.tsx` not matched above | `typescript-reviewer` |

To check for framework signals, read `package.json` in the repo root if it exists:
```bash
cat package.json
```

Additionally, **always include** these three reviewers regardless of file types:
- `code-reviewer` — general quality, readability, correctness, and testing
- `security-auditor` — security vulnerabilities across all file types
- `performance-reviewer` — performance issues across all file types

Present the proposed reviewer list to the user:
> "Based on the changed files, I'll run the following reviewers: [list]. Would you like to add or remove any before I start?"

Wait for user confirmation. Adjust the list if requested.

---

### 8. Delegate to reviewer agents

Fetch the full PR diff:
```bash
gh pr diff <pr>
```

For each confirmed reviewer, invoke it using the Task tool. Run **all reviewer agents in parallel** — send a single message with multiple simultaneous Task tool calls.

Each reviewer's prompt must include:
- The full PR diff from `gh pr diff`
- PR title and body
- List of changed file paths
- All existing PR review comments and PR comments (from step 3) with instructions to avoid re-reporting issues that are already commented on
- If `rally_context` is set: the Rally artifact name, description, and acceptance criteria
- If `previous_review` is set: the list of previously discovered issues with their status (posted/dismissed), with instructions to flag recurring issues but not re-report ones already posted and addressed

Instruct each reviewer to return findings in this **exact structured format**. Each issue must be a separate block:

```
ISSUE: <short title, max 10 words>
SEVERITY: blocking | important | suggestion
CATEGORY: implementation | readability | testing | performance | security | acceptance-criteria
FILE: <relative file path>
LINE: <line number, range like 42-48, or "N/A" if file-level>
DESCRIPTION: <1-3 sentences clearly explaining the problem>
FIX: <1-3 sentences with a concrete suggestion, or "N/A">
```

Also instruct each reviewer to:
- **Ignore** formatting/style issues — the linter handles those
- **Ignore** issues already addressed in existing PR comments
- Focus on **impactful** issues that affect functionality, correctness, readability, performance, or security
- Avoid nitpicking minor details that have no meaningful impact

---

### 9. Compile and deduplicate issues

Collect all `ISSUE:` blocks from all reviewer responses. Then filter:

**Exclude entirely:**
- Formatting or style-only issues (indentation, trailing commas, bracket placement, import ordering)
- Issues where the same file + approximate location + topic already appears in the existing PR comments or reviews fetched in step 3
- Issues already in `previous_review` as `validated-and-posted` — unless the issue clearly recurs in the current diff unchanged

**Flag as `[RECURRING]` (do not exclude, but label):**
- Issues that appeared in `previous_review` as `validated-and-posted` but appear unaddressed in the current diff
- Issues that were previously `dismissed` but appear again — present them without the recurring label (give a fresh look)

Deduplicate within the current batch: if multiple reviewers report the same issue at the same location, merge them into one entry using the most detailed description.

---

### 10. Present issues for user validation

Display all filtered issues grouped by category with clear headers. Use this format:

```
## Security Issues

1. [blocking] src/db/queries.py:88 — SQL query built by string concatenation
   String concatenation in SQL queries allows injection attacks if user input reaches this path.
   Fix: Use parameterized queries — replace f"SELECT * FROM users WHERE id = {user_id}" with a
   prepared statement using ? or %s placeholders.

## Implementation Issues

2. [blocking] src/api/handler.ts:42 — Unhandled promise rejection in fetchUser()
   The call to fetchUser() is not wrapped in try/catch and the returned promise has no .catch()
   handler. Any rejection here will surface as an unhandled rejection in Node.
   Fix: Wrap in try/catch and return a typed error response.

3. [important] src/api/handler.ts:108 — Missing null guard before accessing user.profile
   user can be null when the database returns no result, causing a runtime TypeError.
   Fix: Add a null check: if (!user) return res.status(404).json({ error: 'Not found' })

## Testing Issues

4. [important] src/api/handler.test.ts — No test for the 404 case in getUserById
   The happy path is tested but there is no test asserting a 404 is returned when the user does
   not exist.
   Fix: Add a test that mocks the DB returning null and asserts the response is 404.
```

If a previous review exists, label recurring issues clearly: `[RECURRING]`

After displaying all issues, ask the user to confirm which are valid:
> "Please let me know which issues to dismiss (e.g. 'dismiss 2, 5') or confirm all are valid."

Remove dismissed issues from the list. The remaining issues are the **validated set**.

---

### 11. Post the GitHub review (optional)

Ask the user:
> "Would you like me to post a review on PR #<pr> with the [N] validated issues?"

If yes:

**Post inline comments** for each validated issue that has a specific file path and line number:

```bash
gh api repos/<owner>/<repo>/pulls/<pr>/comments \
  --method POST \
  -f body="<comment body>" \
  -f commit_id="<headRefOid>" \
  -f path="<relative file path>" \
  -F line=<line number>
```

For line ranges, use the last line of the range as the `line` parameter.

For issues with `LINE: N/A`, include them in the overall review body instead.

Keep inline comment bodies concise:
- 1-2 sentences describing the issue clearly
- If a fix is available, include it briefly — 1-3 sentences max
- Do not quote the code back at the author
- Do not use headers or excessive markdown in inline comments

**Post the overall review summary:**
```bash
gh pr review <pr> --comment --body "$(cat <<'EOF'
<summary body>
EOF
)"
```

The overall review body should:
- Open with a brief 2-3 sentence overview of the PR and general observations
- Include a grouped severity summary: `N blocking, N important, N suggestions`
- Call out any particularly well-done aspects if present
- Note any issues with `LINE: N/A` that couldn't be posted inline
- Be concise and focused — do not restate every inline comment

---

### 12. Restore original state

Ask the user:
> "Would you like to switch back to `<original_branch>`[and restore your stashed changes]?"

If yes:
```bash
git checkout <original_branch>
```

If a stash was created in step 4:
```bash
git stash pop
```

---

### 13. Write the review record

Create `~/.reviews/` if it does not exist. Write or update `~/.reviews/REVIEW-<repo>-<pr>.md`.

- If the file **does not exist**: create it with the full metadata header and first review section.
- If the file **exists**: append a new `## Review: <date>` section below the existing ones. Do not modify previous sections.

**File format:**

```markdown
# PR Review: <repo> #<pr>

## PR Metadata
- **Title**: <PR title>
- **Author**: <author username>
- **Branch**: `<headRefName>` → `<baseRefName>`
- **Rally Artifact**: <US/DE ID — Name, or "N/A">

---

## Review: <YYYY-MM-DD>

**Reviewers Used**: <comma-separated agent names>
**Issues Discovered**: <total before filtering>
**Issues After Filtering**: <count after deduplication>
**Issues Validated**: <count user confirmed>
**Review Posted**: Yes / No

### Issues

#### 1. [blocking] SQL injection in src/db/queries.py:88
- **Category**: security
- **File**: `src/db/queries.py:88`
- **Description**: String concatenation in SQL query allows injection.
- **Suggested Fix**: Use parameterized queries.
- **Status**: validated-and-posted
- **Recurring**: No

#### 2. [important] Missing null guard in src/api/handler.ts:108
- **Category**: implementation
- **File**: `src/api/handler.ts:108`
- **Description**: user can be null, causing a runtime TypeError.
- **Suggested Fix**: Add null check before accessing user.profile.
- **Status**: dismissed
- **Recurring**: No
```

Each review session adds a new `## Review: <date>` section. The PR metadata header is written only once and not duplicated on subsequent reviews.

---

## Important Rules

- **Live PR and codebase are always the source of truth.** The review file provides deduplication context only — never suppress fresh findings from reviewer agents based solely on history.
- **Never post a comment for an issue the user dismissed.**
- **Never modify any code in the repository.** This skill orchestrates read-only reviewer agents.
- **Rally context is optional.** If `dops` is not available or the artifact is not found, continue without it.
- **Inline comments require exact file paths and line numbers.** Issues with `LINE: N/A` go in the overall review body only.
- **If the PR is already merged or closed**, warn the user but offer to continue with a local review without posting to GitHub.
