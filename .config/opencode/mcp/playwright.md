---
name: playwright
type: local
command: ["npx", "@playwright/mcp@latest"]
requires_env: []
---

## Description

The official Playwright MCP server from Microsoft. Provides browser automation
using Playwright's accessibility tree — no screenshots or vision models needed.
Enables structured, deterministic interaction with web pages.

## Tools provided

- `browser_navigate` — navigate to a URL
- `browser_snapshot` — capture an accessibility snapshot of the current page
- `browser_click` — click an element by reference
- `browser_type` — type text into an input
- `browser_fill_form` — fill multiple form fields at once
- `browser_select_option` — select a dropdown option
- `browser_hover` — hover over an element
- `browser_drag` — drag and drop between elements
- `browser_press_key` — press a keyboard key
- `browser_take_screenshot` — take a screenshot (view-only; use snapshot for actions)
- `browser_evaluate` — evaluate JavaScript on the page
- `browser_run_code` — run arbitrary Playwright code snippet
- `browser_console_messages` — get browser console output
- `browser_network_requests` — list network requests
- `browser_wait_for` — wait for text or a timeout
- `browser_tabs` — manage browser tabs (list, create, close, select)
- `browser_handle_dialog` — accept or dismiss dialogs
- `browser_resize` — resize the browser window
- `browser_install` — install the configured browser if missing

Optional capability sets (enabled via `--caps`):
- `vision` — coordinate-based mouse tools (`browser_mouse_click_xy`, etc.)
- `pdf` — PDF generation
- `devtools` — Chrome DevTools access

## When to use

- Automating web interactions: form filling, clicking, navigation
- Scraping or inspecting page structure via the accessibility tree
- End-to-end testing workflows from within OpenCode
- Scenarios requiring persistent browser state (cookies, auth sessions)

## Caveats

- Runs headed by default; pass `--headless` for background use
- Adds many tools to context — consider enabling per-agent to control token usage
- Browser profile persists at `~/Library/Caches/ms-playwright/mcp-{channel}-profile`
  on macOS; delete to reset session state
- For coding agents, Microsoft recommends [Playwright CLI + SKILLS](https://github.com/microsoft/playwright-cli)
  over MCP as a more token-efficient alternative

## Setup

No environment variables required. Playwright browsers must be installed:

```
npx playwright install chromium
```

Or let the MCP server install them on first use via the `browser_install` tool.

## opencode.jsonc config

Standard (headed, persistent profile):
```jsonc
"playwright": {
  "type": "local",
  "command": ["npx", "@playwright/mcp@latest"],
  "enabled": true
}
```

Headless with isolated sessions:
```jsonc
"playwright": {
  "type": "local",
  "command": ["npx", "@playwright/mcp@latest", "--headless", "--isolated"],
  "enabled": true
}
```

Specific browser (firefox or webkit):
```jsonc
"playwright": {
  "type": "local",
  "command": ["npx", "@playwright/mcp@latest", "--browser", "firefox"],
  "enabled": true
}
```

Remote/standalone (when running headless on a display-less system):
```jsonc
"playwright": {
  "type": "remote",
  "url": "http://localhost:8931/mcp"
}
```
Start the standalone server with:
```
npx @playwright/mcp@latest --port 8931 --headless
```
