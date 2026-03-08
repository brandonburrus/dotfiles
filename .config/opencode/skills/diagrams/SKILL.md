---
name: diagrams
description: Create ASCII diagrams for any diagramming need using mermaid-ascii. Use whenever a diagram would help — architecture, flows, domain models, state machines, ERDs, class relationships, sequences, pipelines, or any other visual structure. Always produces terminal-renderable ASCII art, never inline Mermaid code blocks. Triggers include "diagram", "visualize", "show the flow", "map out", "architecture diagram", "sequence", "state machine", "draw", or any request to represent a system or process visually.
---

# Diagrams

All diagrams are rendered as ASCII art using [mermaid-ascii](https://github.com/AlexanderGrooff/mermaid-ascii). The output is always a terminal-renderable ASCII diagram — never a Mermaid code block.

## Prime Directive

**Always produce ASCII output.** Write the diagram definition, render it with `mermaid-ascii`, and show the result. Do not output raw Mermaid syntax as the final deliverable.

```bash
# Render from stdin (preferred for one-off diagrams)
echo 'graph LR
  A --> B --> C' | mermaid-ascii

# Render from file
mermaid-ascii -f diagram.mmd

# Adjust spacing
mermaid-ascii -f diagram.mmd -x 8 -y 3

# Pure ASCII (no Unicode box-drawing — use for CI logs, restricted terminals)
mermaid-ascii -f diagram.mmd --ascii
```

## Intent → Diagram Type Mapping

mermaid-ascii supports two diagram types. Map any diagram request to one of them:

| What you want to show                          | Use                  |
|------------------------------------------------|----------------------|
| System architecture, services, infrastructure  | `graph LR` or `TD`   |
| Class relationships, domain models             | `graph LR`           |
| Entity relationships (ERD-style)               | `graph LR`           |
| State machines, lifecycle states               | `graph LR` or `TD`   |
| User flows, processes, decision trees          | `graph TD`           |
| Deployment pipelines, CI/CD                    | `graph LR`           |
| Git branching strategy                         | `graph LR`           |
| API request/response flows                     | `sequenceDiagram`    |
| Component interactions over time               | `sequenceDiagram`    |
| Authentication / authorization flows           | `sequenceDiagram`    |
| Gantt, pie, bar charts (data viz)              | ASCII table/chart    |

## CLI Flags

| Flag                  | Default | Description                                       |
|-----------------------|---------|---------------------------------------------------|
| `-f, --file`          | —       | Input file; `-f -` reads from stdin               |
| `-x, --paddingX`      | 5       | Horizontal space between nodes                    |
| `-y, --paddingY`      | 5       | Vertical space between nodes                      |
| `-p, --borderPadding` | 1       | Padding between node label and box border         |
| `--ascii`             | false   | Pure ASCII only (no Unicode box-drawing chars)    |
| `-c, --coords`        | false   | Show grid coordinates (useful for debugging)      |
| `-v, --verbose`       | false   | Verbose output                                    |

## Quick Examples

### Process / User Flow

```
graph TD
  Start([User visits site]) --> Auth{Authenticated?}
  Auth -->|No| Login[Show login]
  Auth -->|Yes| Dashboard[Show dashboard]
  Login --> Creds[Enter credentials]
  Creds --> Valid{Valid?}
  Valid -->|Yes| Dashboard
  Valid -->|No| Error[Show error]
  Error --> Login
```

```
┌─────────────────────┐
│                     │
│  User visits site   │
│                     │
└──────────┬──────────┘
           │
           │
           │
           │
           ▼
    ┌─────────────┐
    │             │
    │ Authenticated?
    │             │
    └──┬───────┬──┘
       │       │
      No      Yes
       │       │
       ▼       ▼
  ┌────────┐ ┌────────────────┐
  │        │ │                │
  │ Login  │ │ Show dashboard │
  │        │ │                │
  └───┬────┘ └────────────────┘
     ...
```

### Architecture as Graph

```
graph LR
  Client --> Gateway
  Gateway --> AuthService
  Gateway --> UserService
  Gateway --> OrderService
  UserService --> DB[(Postgres)]
  OrderService --> DB
  OrderService --> Queue[(Redis)]
```

```
┌────────┐     ┌─────────┐     ┌─────────────┐     ┌──────────────┐
│        │     │         │     │             │     │              │
│ Client ├────►│ Gateway ├────►│ AuthService │     │  Postgres    │
│        │     │         │     │             │     │              │
└────────┘     └────┬────┘     └─────────────┘     └──────┬───────┘
                    │                                      ▲
                    │          ┌─────────────┐             │
                    │          │             ├─────────────┘
                    ├─────────►│ UserService │
                    │          │             │
                    │          └─────────────┘
                   ...
```

### Domain Model / Class Relationships

Use labeled edges to convey relationship semantics instead of UML shape notation:

```
graph LR
  User -->|places| Order
  Order -->|contains| LineItem
  Product -->|included in| LineItem
  User -->|has many| Address
  Order -->|ships to| Address
```

### State Machine

```
graph LR
  Idle -->|submit| Pending
  Pending -->|approve| Active
  Pending -->|reject| Rejected
  Active -->|cancel| Cancelled
  Active -->|complete| Done
  Rejected -->|resubmit| Pending
```

### API Sequence

```
sequenceDiagram
  participant Client
  participant API
  participant DB
  Client->>API: POST /login
  API->>DB: SELECT user WHERE email=?
  DB-->>API: user record
  API-->>Client: 200 OK + JWT
```

```
┌────────┐     ┌─────┐     ┌────┐
│ Client │     │ API │     │ DB │
└───┬────┘     └──┬──┘     └─┬──┘
    │             │           │
    │ POST /login │           │
    ├────────────►│           │
    │             │ SELECT... │
    │             ├──────────►│
    │             │           │
    │             │ user record│
    │             │◄┈┈┈┈┈┈┈┈┈┈┤
    │             │           │
    │ 200 OK+JWT  │           │
    │◄┈┈┈┈┈┈┈┈┈┈┈┈┤           │
    │             │           │
```

### Data Visualization Fallback (Gantt / Pie / Bar)

For data that doesn't map to a graph or sequence, produce a plain-text ASCII table or bar chart:

**Bar chart:**
```
Requests/sec by service

AuthService   ████████████████░░░░  800
UserService   ████████████░░░░░░░░  600
OrderService  ████████████████████  1000
Gateway       ████████████████████  1000
              0          500       1000
```

**Gantt-style table:**
```
Phase          Week 1   Week 2   Week 3   Week 4
─────────────────────────────────────────────────
Design         ████████
Development             ████████ ████████
Testing                          ████████ ████████
Deploy                                    ████████
```

## Best Practices

1. **Use `graph`, not `flowchart`** — mermaid-ascii uses the older `graph` keyword; `flowchart` is not supported
2. **All nodes render as rectangles** — don't rely on shape to convey meaning; use labels and edge text instead
3. **Labels carry semantics** — in place of UML arrows or ERD notation, use `-->|relationship name|` on edges
4. **Watch terminal width** — wide graphs can exceed 80 columns; prefer `graph TD` for deep hierarchies and `graph LR` for wide ones; use `-x 3` to tighten horizontal spacing
5. **`--ascii` for portability** — use when rendering in CI logs or terminals that may not support Unicode box-drawing characters
6. **Stdin for quick iteration** — pipe diagram definitions directly rather than writing temp files
7. **Subgraphs for grouping** — use `subgraph` to represent layers, modules, bounded contexts, or deployment zones
8. **`classDef` for color-coding** — differentiate node categories (e.g., services vs. datastores vs. external systems) using `classDef name color:#hex`

## Detailed References

- **[references/flowcharts.md](references/flowcharts.md)** — Full graph syntax: directions, edges, labels, multi-edges, subgraphs, classDef, patterns for architecture/domain/state/process diagrams
- **[references/sequence-diagrams.md](references/sequence-diagrams.md)** — Participants, arrows, self-messages, aliases, supported vs. not-yet-supported features
