---
name: rally-defect-to-github-release
keywords:
  - rally
  - defect
  - github
  - release
  - QA
  - verification
  - pull request
  - tracing
  - dops-portal
  - workflow
description: >-
  Documents the step-by-step workflow for tracing a Rally defect or user story
  to its corresponding GitHub release. Useful when doing QA verification and
  needing to identify which release contains a specific fix.
---
## Workflow: Finding a GitHub Release from a Rally Defect/Story

### Steps
1. Use `rsg-rally_get-pull-requests` with the Rally artifact ID (e.g. DE44330 or US12345)
   - This returns the GitHub PR(s) linked to the Rally item, including the PR number, title, and URL

2. Use `github_pull_request_read` (method: `get`) with the owner, repo, and PR number
   - Confirms the PR is merged, which branch it targeted, and the merge date

3. Use `github_list_releases` to list recent releases for the repo
   - Scan release bodies/changelogs — each release typically lists its included PRs
   - Match the PR number to identify the first release containing the fix

### Key Details
- Repo: RepublicServicesRepository/dops-portal
- Releases on `develop` branch follow the pattern: `YYYY.4.1.X`
- Releases on `release*` branches follow patterns like: `YYYY.3.1.X`, `YYYY.2.3.X`
- Release changelogs explicitly list merged PRs, making it easy to match

### Example
- DE44330 → PR #5525 → Release **2026.4.1.22**
  - PR merged into `develop` on Feb 27, 2026
  - Release 2026.4.1.22 published same day, lists PR #5525 as its only change
