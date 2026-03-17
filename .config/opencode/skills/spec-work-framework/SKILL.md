---
name: spec-work-framework
description: Apply the Spec Work Framework (SWF) to projects — creates and maintains a structured specs/ directory with PRD, ARCHITECTURE, ROADMAP, CHANGELOG, ADRs, feature specs, and task files. Use whenever "SWF" is mentioned or when the user wants to organize a project using specs-driven development.
---

# Spec Work Framework (SWF)

## What I do

Guide agents and users through a specs-driven development process. I define the directory structure, document formats, task lifecycle, and agentic work loop used to plan, execute, and track work on any software project. All specs live in a `specs/` directory at the project root.

## When to use me

- The user mentions **SWF**
- The user wants to set up specs for a project
- The user wants to create a PRD, ARCHITECTURE doc, feature spec, ADR, or task
- The user wants to start working on a task agentic ally
- The user wants to review the state of a project's specs

---

## Directory Structure

```
specs/
├── PRD.md
├── ARCHITECTURE.md
├── ROADMAP.md
├── CHANGELOG.md
├── adr/
│   └── <slug>.md
├── features/
│   └── <feature-name>.md
└── work/
    ├── todo/
    │   └── <task-name>-<type>.yaml
    ├── in-progress/
    │   └── <task-name>-<type>.yaml
    ├── in-review/
    │   └── <task-name>-<type>.yaml
    ├── blocked/
    │   └── <task-name>-<type>.yaml
    └── done/
        └── <task-name>-<type>.yaml
```

---

## High-Level Documents

### PRD.md

**What it is:** A strictly non-technical document defining what the product is, who it is for, and what problem it solves. It is a living document — always reflecting the current vision. Historical changes are not tracked here; use the CHANGELOG and ADRs for history.

**Follows:** SVPG guidelines (https://www.svpg.com/wp-content/uploads/2024/07/How-To-Write-a-Good-PRD.pdf)

**Required sections:**
- **Purpose** — The problem being solved and why it matters
- **Target Users** — Who the product is for (personas, roles, or user types)
- **Goals & Success Metrics** — Measurable outcomes that define success (e.g., "reduce onboarding time by 50%", "90% user retention at day 30")
- **Key Assumptions** — Critical assumptions the product strategy depends on; if wrong, the product direction changes
- **Known Risks** — Risks that could prevent success, with proposed mitigations
- **Out of Scope** — Explicit list of what this product does NOT do
- **Open Questions** — Unresolved questions that need answers before or during development

**Rules:**
- No technical implementation details
- No references to specific technologies, frameworks, or infrastructure
- Must be understandable by a non-technical stakeholder

---

### ARCHITECTURE.md

**What it is:** The high-level technical design of the system. Covers technology choices, system-level design decisions, and overall structure. Does NOT contain implementation instructions for specific features.

**Required sections:**
- **System Overview** — A brief description of the system and its major components
- **Technology Choices** — Languages, frameworks, databases, infrastructure platforms, and rationale
- **System Design** — Architecture pattern (monolith, microservices, serverless, etc.) and the reasoning
- **Data Model Overview** — High-level entities and relationships (not schema-level detail)
- **API Design** — REST vs GraphQL vs gRPC, conventions, versioning strategy
- **Authentication & Authorization** — Approach and mechanism chosen
- **Deployment & Infrastructure** — How the system is deployed and hosted
- **Non-Functional Requirements** — Performance targets, scalability approach, reliability expectations
- **Key Constraints** — Technical constraints that affect all design decisions (e.g., "must run on-premise", "must support IE11")

**Rules:**
- Decisions here should be recorded as ADRs when they involve meaningful tradeoffs
- Feature-specific technical designs belong in feature specs, not here

---

### ROADMAP.md

**What it is:** A forward-looking document tracking what needs to be built, in what order, and why. Its primary purpose is documenting *future* work and the dependencies between work items.

**Required sections:**
- **Now** — Work currently in progress or next up
- **Next** — Work planned after current items complete
- **Later** — Future work that is defined but not yet scheduled
- **Dependencies Map** — Notes on ordering constraints between work items

**Rules:**
- Items here should correspond to features in `specs/features/` once specced
- Completed items move to CHANGELOG.md, not tracked here
- Keep entries at the feature/milestone level, not individual task level

---

### CHANGELOG.md

**What it is:** A record of all past notable changes to the project. Tracks completed work chronologically.

**Follows:** Keep a Changelog format (https://keepachangelog.com/en/1.0.0/)

**Format:**
```markdown
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [Unreleased]

## [1.0.0] - YYYY-MM-DD

### Added
- New features

### Changed
- Changes to existing functionality

### Deprecated
- Soon-to-be removed features

### Removed
- Removed features

### Fixed
- Bug fixes

### Security
- Vulnerability fixes
```

**Rules:**
- Update this file every time a task moves to `done/`
- Changelogs are for humans — write meaningful descriptions, not git log noise
- Always maintain an `[Unreleased]` section at the top for changes not yet versioned

---

## Architecture Decision Records (ADRs)

**Location:** `specs/adr/`

**What they are:** Short documents that capture the context, decision, alternatives considered, and consequences of significant technical decisions. ADRs are immutable once accepted — they record *history*. If a decision is reversed, create a new ADR superseding the old one.

**Filename format:** `<slug>.md` (e.g., `use-postgresql-for-primary-db.md`, `adopt-event-sourcing.md`)

**Template:**
```markdown
# ADR: <Title>

**Date:** YYYY-MM-DD
**Status:** Proposed | Accepted | Superseded by [slug]

## Context
What situation or problem prompted this decision? What constraints exist?

## Decision
What was decided?

## Alternatives Considered
- **Option A** — Description and why it was not chosen
- **Option B** — Description and why it was not chosen

## Consequences
What becomes easier or harder as a result of this decision?
What new constraints does this introduce?
```

**When to create an ADR:**
- Any architectural choice with meaningful tradeoffs
- When reversing or changing a previous architectural decision
- When a constraint is discovered that locks in a design direction

---

## Feature Specs

**Location:** `specs/features/<feature-name>.md`

**What they are:** Detailed specifications for individual product features. Each feature gets its own document.

**Required sections:**

1. **Overview** — High-level description of the feature, its purpose, and how it fits into the product
2. **User Stories** — Functionality described from the end user's perspective (`As a <user>, I want to <action> so that <outcome>`)
3. **Acceptance Criteria** — Explicit, testable criteria that must be met for the feature to be complete (functional and non-functional)
4. **Design** — High-level structure and flow of the feature. May include diagrams or mockups. No implementation-level detail
5. **Dependencies** — Other features, services, or external systems this feature depends on
6. **Testing** — How the feature will be verified, including key test scenarios and both manual and automated testing strategies
7. **Implementation Notes** — Considerations developers should know: potential challenges, performance implications, security concerns

**Example:**
```markdown
# Chat Feature

## Overview
The chat feature allows users to send and receive messages in real-time...

## User Stories
- As a user, I want to send messages to other users so that I can communicate with them.
- As a user, I want to see when other users are typing so that I can have a more interactive experience.

## Acceptance Criteria
- Users can send and receive messages in real-time.
- Typing indicators are shown when another user is composing.
- The feature is responsive on desktop and mobile.

## Design
WebSocket-based real-time communication. Frontend renders a message thread per conversation...

## Dependencies
- Requires: User Authentication feature
- Requires: Notification feature

## Testing
Automated: unit tests for message validation, integration tests for WebSocket lifecycle.
Manual: end-to-end send/receive across two sessions, network interruption handling.

## Implementation Notes
- Implement message pagination to avoid performance degradation at scale.
- Sanitize all message content to prevent XSS.
```

---

## Tasks

**Location:** `specs/work/{todo,in-progress,in-review,blocked,done}/`

**What they are:** The smallest actionable unit of work. Every task is either a user story implementation or a bugfix. Tasks should be scoped small enough to be completed as a single unit.

**Filename format:** `<name>-<type>.yaml`
- Types: `user-story` or `bugfix`
- Examples: `send-chat-message-user-story.yaml`, `fix-message-ordering-bugfix.yaml`

**Task lifecycle directories:**
- `todo/` — Defined, not yet started
- `in-progress/` — Currently being worked on (move file here when starting)
- `in-review/` — Implementation complete, under review (move file here when done implementing)
- `blocked/` — Cannot proceed due to an unresolved dependency or external blocker
- `done/` — Fully complete, reviewed, and accepted (move file here after review passes)

**Task YAML schema:**

```yaml
title: "Short description of the task"
type: user-story  # or: bugfix
feature: "<feature-name>"  # must match a filename in specs/features/ (without .md)
description: "Full description. For user-story: 'As a <user>, I want to <action> so that <outcome>.' For bugfix: describe the bug and expected vs actual behavior."
acceptance_criteria:
  - "Specific, testable criterion"
  - "Another criterion"
blocked_by:
  - "<task-filename-without-extension>"  # e.g., "setup-auth-user-story". Agent checks if this task is in done/ before starting.
review_focus:
  - performance   # optional: triggers performance review subagent
  - security      # optional: triggers security review subagent
technical_notes:
  - "Implementation guidance, constraints, or known gotchas"
```

**Definition of Done:** A task is only moved to `done/` when ALL of the following are true:
1. The implementation is complete
2. Automated tests cover the implementation
3. All tests are passing
4. The fulfillment review subagent has signed off (see Review Process below)
5. Any triggered specialized review subagents (performance, security) have signed off

---

## Agentic Work Loop

When working on this project agentically, follow this loop strictly:

```
PLAN → SPEC → REFINE SPECS → WORK → TEST → REVIEW → UPDATE SPECS → PLAN (repeat)
```

### Phase 1: PLAN
- Read `specs/PRD.md`, `specs/ARCHITECTURE.md`, and `specs/ROADMAP.md`
- Review all tasks in `specs/work/todo/` and `specs/work/in-progress/`
- Identify the next task to work on based on roadmap priority and dependency resolution
- Before starting a task, verify all tasks in its `blocked_by` list are present in `done/`
- If a task is blocked, move it to `blocked/` and select the next available task

### Phase 2: SPEC
Before writing any code, rigorously question the user to ensure specs are well-defined:
- Is the relevant feature spec complete? If not, create or complete it
- Are the acceptance criteria testable and unambiguous?
- Are all dependencies identified?
- Does the task align with the PRD goals?

Do not proceed to WORK until specs are confirmed by the user.

### Phase 3: REFINE SPECS
- Present the drafted/updated specs to the user
- Iterate until the user confirms the specs accurately reflect their intent
- Update the feature spec and task YAML to reflect any refinements
- This step must occur before any implementation begins

### Phase 4: WORK
- Move the task file from `todo/` to `in-progress/`
- Implement the feature or fix as described in the task and feature spec
- Follow all decisions in `ARCHITECTURE.md`
- Do not deviate from the spec without flagging it to the user first

### Phase 5: TEST
- Write automated tests that cover the implementation
- All tests must pass before proceeding
- Test coverage should reflect the acceptance criteria in the task YAML

### Phase 6: REVIEW
Move the task file to `in-review/` and launch review subagents:

**Fulfillment Review (always required):**
- Use a dedicated subagent that has NOT worked on the implementation
- The reviewer reads the task YAML and feature spec, then reviews the code and tests
- Verifies: all acceptance criteria are met, tests exist and are meaningful, implementation matches spec
- If issues are found, the reviewer and implementer go back and forth until the reviewer is satisfied
- The fulfillment review subagent has final say on spec fulfillment

**Performance Review (triggered when `review_focus` includes `performance`):**
- A separate performance-specialist subagent reviews the implementation for bottlenecks, inefficient algorithms, unnecessary re-renders, N+1 queries, or scalability issues
- Must sign off before the task can move to `done/`

**Security Review (triggered when `review_focus` includes `security`):**
- A separate security-specialist subagent reviews for vulnerabilities: injection risks, improper auth checks, insecure data handling, exposed secrets, etc.
- Must sign off before the task can move to `done/`

All active review subagents must independently sign off. If any reviewer raises blocking issues, the task returns to `in-progress/` for fixes, then back to `in-review/`.

### Phase 7: UPDATE SPECS
After a task passes all reviews:
- Move the task file from `in-review/` to `done/`
- Update `specs/CHANGELOG.md` with a human-readable entry describing what was built
- Update `specs/ROADMAP.md` to reflect completed work
- Update `specs/PRD.md` or `specs/ARCHITECTURE.md` if the implementation revealed new information that changes the current state of the project
- Create a new ADR in `specs/adr/` if a new significant technical decision was made during implementation

Then return to **PLAN**.

---

## Bootstrapping a New Project

When setting up SWF for a project for the first time:

1. Ask the user the following questions (do not skip any):
   - What is this project? What problem does it solve?
   - Who are the target users?
   - What does success look like? How will you measure it?
   - What are the key assumptions you're making?
   - What is explicitly out of scope?
   - Are there any known technical constraints or preferences (language, platform, hosting)?
   - What are the highest-priority features to build first?

2. Draft `specs/PRD.md` from the answers and review it with the user before proceeding.

3. Draft `specs/ARCHITECTURE.md` once the PRD is approved.

4. Draft `specs/ROADMAP.md` with an initial feature breakdown.

5. Create `specs/CHANGELOG.md` with an empty `[Unreleased]` section.

6. Create the `specs/adr/`, `specs/features/`, and `specs/work/{todo,in-progress,in-review,blocked,done}/` directories.

7. For each roadmap item, ask the user enough questions to draft the corresponding feature spec in `specs/features/`.

8. Break approved feature specs into tasks and place them in `specs/work/todo/`.

9. Review all created specs with the user before beginning any implementation work.

**Do not write a single line of implementation code until the user has reviewed and approved the initial specs.**

---

## Rules for Maintaining Specs

- **PRD.md** is always current — update it when the product vision changes. It does not track history.
- **ARCHITECTURE.md** is always current — update it when architectural decisions change. Create an ADR when doing so.
- **ROADMAP.md** tracks future work only — remove items when they are completed.
- **CHANGELOG.md** tracks past work only — add entries when tasks are completed.
- **ADRs are immutable** — never edit an accepted ADR. Supersede it with a new one.
- **Feature specs evolve** — update them as understanding deepens, but keep them aligned with the PRD.
- **Tasks are small** — if a task would take more than a day or two, break it into smaller tasks.
- **Specs precede code** — never start implementation without an approved spec and task.
