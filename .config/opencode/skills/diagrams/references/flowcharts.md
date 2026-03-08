# Graphs & Flowcharts

Use `graph LR` or `graph TD` to express processes, architectures, domain models, state machines, and any other node/edge structure. All output is rendered via `mermaid-ascii`.

> **Note:** Use the `graph` keyword — mermaid-ascii does not support the newer `flowchart` keyword.

## Basic Syntax

```
graph LR
  A --> B
```

```bash
echo 'graph LR
  A --> B' | mermaid-ascii
```

Output:
```
┌───┐     ┌───┐
│   │     │   │
│ A ├────►│ B │
│   │     │   │
└───┘     └───┘
```

## Directions

| Keyword    | Layout           |
|------------|------------------|
| `LR`       | Left to Right    |
| `RL`       | Right to Left    |
| `TD` / `TB`| Top to Bottom    |

Use `LR` for pipelines, timelines, and wide graphs. Use `TD` for hierarchies, decision trees, and deep flows.

## Node Labels

Nodes default to using their identifier as the label. Add a label with square brackets:

```
graph LR
  svc[Auth Service] --> db[(Postgres)]
  svc --> cache[Redis Cache]
```

> All nodes render as rectangles in mermaid-ascii regardless of bracket style. Do not use shape syntax to convey meaning — use labels and edge text instead.

## Edges

### Basic Arrow
```
A --> B
```

### Open Link (no arrowhead)
```
A --- B
```

### Labeled Edge
```
A -->|label text| B
```

Labeled edges are the primary tool for conveying relationship semantics in place of UML notation:

```
graph LR
  User -->|places| Order
  Order -->|contains| LineItem
  Product -->|included in| LineItem
```

### Chaining
```
A --> B --> C --> D
```

### Multiple Targets (`A & B` syntax)
```
graph LR
  A --> B & C
  B & C --> D
```

Output:
```
┌───┐     ┌───┐     ┌───┐
│   │     │   │     │   │
│ A ├────►│ B ├────►│ D │
│   │     │   │     │   │
└─┬─┘     └───┘     └─▲─┘
  │                   │
  │       ┌───┐       │
  │       │   │       │
  └──────►│ C ├───────┘
          │   │
          └───┘
```

### Multiple Arrows on One Line
```
A --> B --> C
```

## Subgraphs

Group nodes into logical clusters — useful for layers, modules, bounded contexts, or deployment zones:

```
graph LR
  subgraph Frontend
    UI[React App]
    BFF[Next.js BFF]
  end

  subgraph Backend
    API[REST API]
    Worker[Job Worker]
  end

  subgraph Data
    DB[(Postgres)]
    Queue[(Redis)]
  end

  UI --> BFF
  BFF --> API
  API --> DB
  Worker --> DB
  Worker --> Queue
  API --> Queue
```

### Nested Subgraphs
```
graph TD
  subgraph Cloud
    subgraph VPC
      App[Application]
      DB[(Database)]
    end
    CDN[CDN]
  end
  CDN --> App
  App --> DB
```

## Color-Coding with classDef

Use `classDef` to differentiate node categories. In mermaid-ascii, only `color:#hex` is supported (text color — no fill or stroke):

```
graph LR
  classDef service color:#00aaff
  classDef datastore color:#ffaa00
  classDef external color:#ff4444

  Client:::external --> Gateway:::service
  Gateway --> Auth:::service
  Gateway --> Orders:::service
  Auth --> DB:::datastore
  Orders --> DB:::datastore
```

## Patterns

### Process / Decision Flow

```
graph TD
  Start([Begin]) --> Step1[Validate input]
  Step1 --> Check{Valid?}
  Check -->|Yes| Step2[Process request]
  Check -->|No| Error[Return error]
  Step2 --> Done([Complete])
```

> Node shapes like `([...])` and `{...}` are valid Mermaid syntax but render as rectangles in mermaid-ascii. Use labels to convey "start", "end", or "decision" meaning.

### System Architecture

```
graph LR
  subgraph Public
    LB[Load Balancer]
  end

  subgraph Services
    API[API Server]
    Auth[Auth Service]
    Notif[Notification Service]
  end

  subgraph Storage
    DB[(Primary DB)]
    Cache[(Redis)]
    Queue[(Message Queue)]
  end

  LB --> API
  API --> Auth
  API --> DB
  API --> Cache
  API --> Queue
  Queue --> Notif
```

### Domain Model / Class Relationships

Replace UML associations with labeled edges:

| UML                      | Graph equivalent                    |
|--------------------------|-------------------------------------|
| `A "1" -- "many" B`      | `A -->|has many| B`                 |
| `A --|> B` (inherits)    | `A -->|extends| B`                  |
| `A --o B` (aggregation)  | `A -->|contains| B`                 |
| `A --* B` (composition)  | `A -->|owns| B`                     |
| `A ..> B` (dependency)   | `A -->|depends on| B`               |

```
graph LR
  User -->|places| Order
  Order -->|contains| LineItem
  Product -->|included in| LineItem
  User -->|has| Address
  Order -->|ships to| Address

  Admin -->|extends| User
  GuestUser -->|extends| User
```

### State Machine

States map directly to nodes; transitions map to labeled edges:

```
graph LR
  Idle -->|submit| Pending
  Pending -->|approve| Active
  Pending -->|reject| Rejected
  Active -->|suspend| Suspended
  Active -->|complete| Done
  Suspended -->|resume| Active
  Rejected -->|resubmit| Pending
```

### CI/CD Pipeline

```
graph LR
  subgraph Dev
    Commit --> Push
  end

  subgraph CI
    Push --> Lint
    Lint --> Test
    Test --> Build
  end

  subgraph CD
    Build -->|pass| DeployStaging[Deploy Staging]
    DeployStaging --> Smoke[Smoke Tests]
    Smoke -->|pass| DeployProd[Deploy Prod]
    Smoke -->|fail| Rollback
  end

  Build -->|fail| Notify[Notify Dev]
```

### Git Branching

```
graph LR
  main --> feature1[feature/auth]
  main --> feature2[feature/payments]
  feature1 -->|merge| main
  feature2 -->|merge| main
  main -->|tag v1.2| release[release/1.2]
  main --> hotfix[hotfix/critical-bug]
  hotfix -->|merge| main
```

## Spacing Adjustments

```bash
# Tighten horizontal spacing for wide graphs
mermaid-ascii -f diagram.mmd -x 3

# Increase padding for longer node labels
mermaid-ascii -f diagram.mmd -p 2

# Expand vertical spacing
mermaid-ascii -f diagram.mmd -y 3

# All adjustments combined
mermaid-ascii -f diagram.mmd -x 4 -y 3 -p 2
```

## Best Practices

1. **Labels over shapes** — all nodes render as rectangles; use text labels and edge labels for semantics
2. **Labeled edges are first-class** — `-->|relationship|` carries the meaning that UML arrow types, cardinality, and notation normally would
3. **Subgraphs for context boundaries** — use them freely to show layers, teams, deployment zones, or modules
4. **`LR` for wide structures, `TD` for deep hierarchies** — match direction to the natural shape of the graph
5. **Keep node IDs short** — the label in `[...]` is what displays; the identifier before it can be terse for clean syntax
6. **Use `classDef` for categories** — color-code services, datastores, external systems, and actors to aid readability
7. **Watch width** — use `-x 3` or `-x 4` to reduce horizontal spread when graphs approach 80+ columns
