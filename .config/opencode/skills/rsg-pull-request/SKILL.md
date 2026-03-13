---
name: rsg-pull-request
description: Create a work-related pull request for a Republic Services (RSG) repo under the RepublicServicesRepository GitHub org. Ensures changes are committed, fetches Rally story/defect context, populates the repo's PR template, and guides the user through review before creating the PR.
---

## What I do

Guide the full workflow for opening a pull request against a
`RepublicServicesRepository` GitHub repo: verifying the working tree is clean,
fetching Rally artifact context, populating the repo's PR template, and
creating the PR via GitHub after the user reviews and approves the draft.

## When to use me

- The user wants to open a PR for work tracked in Rally (user story or defect)
- The target repo is under the `RepublicServicesRepository` GitHub org

## Workflow

### 1. Ensure all changes are committed

Load the `rsg-branching-commiting` skill and run through its full workflow. If the
working tree is already clean, the skill will exit early and this step is
effectively a no-op. Do not proceed to step 2 until the working tree is clean.

### 2. Identify the Rally artifact ID

Parse the current branch name using `git branch --show-current` and look for a
`US` or `DE` pattern using `(US|DE)\d+`.

- If found, extract it (e.g. `US123456` or `DE789012`).
- If not found, ask the user to provide the Rally artifact ID.

### 3. Fetch Rally artifact details

Use the Rally MCP tools to retrieve the artifact:

- For a `US######` ID → call `rsg-rally_get-user-story`
- For a `DE######` ID → call `rsg-rally_get-defect`

Extract the artifact's **name** and **description** to inform the PR title and
body. If the Rally MCP is unavailable or the artifact is not found, ask the
user to provide a brief title and description manually and continue.

### 4. Determine the repository name

Derive the repo name from the git remote:

```bash
git remote get-url origin
```

Parse the repository name from the URL (the part after the last `/`, without
`.git`). The owner is always `RepublicServicesRepository`.

### 5. Confirm the target base branch

Always ask the user which branch to target. Do not assume a default. Common
options in RSG repos are `develop` and `main` — suggest those as options but
let the user confirm or provide a different one.

### 6. Get the PR description template

Run the following command to fetch the repo's PR template:

```bash
gh api repos/RepublicServicesRepository/{repo}/contents/.github/pull_request_template.md -q .content | base64 --decode
```

If the command succeeds, use the decoded content as the base for the PR description.

If the command fails (file not found or any other error), use this fallback template:

```markdown
## Summary

- 

## Changes

- 

## Testing

- 
```

### 7. Draft the PR title and description

**Title format:**
```
US123456: <concise description>
```
- Derive the description from the Rally artifact name (step 3) or the branch
  name if Rally was unavailable.
- Use sentence case, imperative mood, no trailing period.
- Keep it under 72 characters total where possible.

**Description:**
- Populate the template from step 6 using the Rally artifact's name and
  description as context.
- Fill in what is known; leave template placeholders clearly marked where the
  user should add detail.
- Do not invent specifics — if a section requires detail only the user knows
  (e.g. testing steps), leave a clear prompt for them to fill in.

### 8. User review loop

Present the draft title and description to the user. Ask:

> "Does this look good, or would you like to make any changes before I create
> the PR?"

Offer to revise any part of the title or description. Repeat until the user
explicitly approves. Do not create the PR until the user confirms.

### 9. Create the PR

Run `gh pr create` using a HEREDOC to pass the body safely:

```bash
gh pr create \
  --repo "RepublicServicesRepository/{repo}" \
  --title "{approved title}" \
  --base "{base branch}" \
  --body "$(cat <<'EOF'
{approved description}
EOF
)"
```

After the PR is created, display the PR URL to the user.
