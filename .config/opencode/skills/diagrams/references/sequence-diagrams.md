# Sequence Diagrams

Use `sequenceDiagram` to show interactions between participants over time — API flows, authentication sequences, component communication, and message passing.

## Basic Syntax

```
sequenceDiagram
  participant A
  participant B
  A->>B: Message
  B-->>A: Response
```

```bash
echo 'sequenceDiagram
  participant Client
  participant Server
  Client->>Server: Request
  Server-->>Client: Response' | mermaid-ascii
```

Output:
```
┌────────┐     ┌────────┐
│ Client │     │ Server │
└───┬────┘     └───┬────┘
    │              │
    │   Request    │
    ├─────────────►│
    │              │
    │   Response   │
    │◄┈┈┈┈┈┈┈┈┈┈┈┈┈┤
    │              │
```

## Participants

Declare participants explicitly to control their order in the diagram:

```
sequenceDiagram
  participant Client
  participant Gateway
  participant AuthService
  participant DB
```

Without explicit declaration, participants appear in the order they are first mentioned.

### Aliases

Use `as` to display a friendly name while keeping a short identifier in the diagram body:

```
sequenceDiagram
  participant C as Client
  participant G as API Gateway
  participant A as Auth Service
  C->>G: GET /profile
  G->>A: Validate token
  A-->>G: Valid
  G-->>C: 200 OK
```

Output:
```
┌────────┐     ┌─────────────┐     ┌──────────────┐
│ Client │     │ API Gateway │     │ Auth Service │
└───┬────┘     └──────┬──────┘     └──────┬───────┘
    │                 │                   │
    │  GET /profile   │                   │
    ├────────────────►│                   │
    │                 │  Validate token   │
    │                 ├──────────────────►│
    │                 │                   │
    │                 │      Valid        │
    │                 │◄┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┤
    │                 │                   │
    │     200 OK      │                   │
    │◄┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┤                   │
    │                 │                   │
```

## Arrow Types

| Syntax    | Meaning                           | Renders as      |
|-----------|-----------------------------------|-----------------|
| `A->>B`   | Solid arrow (request / call)      | `────────────►` |
| `A-->>B`  | Dotted arrow (response / return)  | `◄┈┈┈┈┈┈┈┈┈┈┈┈` |

Use solid arrows for calls/requests and dotted arrows for responses/returns. This mirrors the standard sequence diagram convention.

## Self-Messages

A participant can send a message to itself — useful for showing internal processing:

```
sequenceDiagram
  participant API
  participant DB
  API->>API: Validate JWT
  API->>DB: SELECT user
  DB-->>API: user record
  API->>API: Build response
```

Output (self-message portion):
```
    │ Validate JWT │
    ├──┐           │
    │  │           │
    │◄─┘           │
```

## Multiple Participants

```
sequenceDiagram
  participant Client
  participant API
  participant Auth
  participant DB

  Client->>API: POST /orders
  API->>Auth: Verify token
  Auth-->>API: Token valid
  API->>DB: INSERT order
  DB-->>API: order_id=42
  API-->>Client: 201 Created
```

## Common Patterns

### Request / Response

```
sequenceDiagram
  participant Client
  participant API
  participant DB
  Client->>API: GET /users/123
  API->>DB: SELECT * FROM users WHERE id=123
  DB-->>API: user record
  API-->>Client: 200 OK + user JSON
```

### Authentication Flow

```
sequenceDiagram
  participant User
  participant Frontend
  participant API
  participant DB

  User->>Frontend: Enter credentials
  Frontend->>API: POST /auth/login
  API->>DB: SELECT user WHERE email=?
  DB-->>API: user record
  API->>API: Verify password hash
  API-->>Frontend: 200 OK + JWT
  Frontend-->>User: Redirect to dashboard
```

### Service-to-Service

```
sequenceDiagram
  participant OrderService
  participant PaymentService
  participant InventoryService
  participant NotificationService

  OrderService->>PaymentService: Charge card
  PaymentService-->>OrderService: Payment confirmed
  OrderService->>InventoryService: Reserve stock
  InventoryService-->>OrderService: Stock reserved
  OrderService->>NotificationService: Send confirmation email
  NotificationService-->>OrderService: Queued
```

### Error Path

Show the happy path and the error case as separate sequence diagrams rather than trying to branch within one. Keep each diagram focused on a single scenario:

**Happy path:**
```
sequenceDiagram
  participant Client
  participant API
  Client->>API: POST /login
  API-->>Client: 200 OK + JWT
```

**Error path:**
```
sequenceDiagram
  participant Client
  participant API
  Client->>API: POST /login
  API->>API: Verify credentials
  API-->>Client: 401 Unauthorized
```

## Not Yet Supported by mermaid-ascii

The following Mermaid sequence diagram features parse correctly but are not rendered by mermaid-ascii. Avoid them — they will either be silently dropped or cause unexpected output:

| Feature                        | Syntax example                     |
|--------------------------------|------------------------------------|
| Conditional blocks             | `alt / else / end`                 |
| Optional blocks                | `opt / end`                        |
| Parallel blocks                | `par / and / end`                  |
| Loop blocks                    | `loop / end`                       |
| Break                          | `break / end`                      |
| Notes                          | `Note over A: text`                |
| Activation boxes               | `A->>+B` / `B-->>-A`              |
| Auto-numbering                 | `autonumber`                       |
| `actor` keyword                | `actor User`                       |

**Workaround:** Express branching and loops as separate focused diagrams (one for each path/scenario) rather than using `alt`/`loop` blocks within a single diagram.

## Best Practices

1. **Order participants left-to-right** in the natural call direction — typically: User → Frontend → API → Service → Database
2. **Use aliases** to keep diagram syntax terse while showing meaningful display names
3. **Solid for calls, dotted for responses** — consistent arrow direction makes flows easier to follow
4. **One scenario per diagram** — since `alt/opt/loop` aren't supported, split branching flows into separate diagrams for happy path, error path, edge cases
5. **Self-messages for internal state** — use `A->>A: action` to show processing steps that don't involve other participants
6. **Keep participant counts low** — diagrams with more than 5–6 participants get very wide; split into multiple diagrams at service boundaries
7. **Use `--ascii` in restricted environments** — the default Unicode output may not render correctly in some CI logs or terminals

## Spacing for Wide Diagrams

Long participant names or many participants can make sequence diagrams exceed terminal width:

```bash
# Reduce horizontal spacing between participants
mermaid-ascii -f diagram.mmd -x 3

# Increase only if labels are very long and overlapping
mermaid-ascii -f diagram.mmd -x 8
```
