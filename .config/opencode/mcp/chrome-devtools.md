---
name: chrome-devtools
type: local
command: ["npx", "-y", "chrome-devtools-mcp@latest"]
requires_env: []
---

## Description

The official Chrome DevTools MCP server from the Chrome DevTools team. Provides
full browser control via Puppeteer and exposes Chrome DevTools capabilities:
performance tracing, network inspection, Lighthouse audits, memory snapshots,
and console debugging with source-mapped stack traces.

## Tools provided

**Input automation**
- `click` — click an element on the page
- `drag` — drag from one element/point to another
- `fill` — fill a single input field
- `fill_form` — fill multiple form fields at once
- `handle_dialog` — accept or dismiss browser dialogs
- `hover` — hover over an element
- `press_key` — press a keyboard key or combination
- `type_text` — type text (character by character, useful for inputs with handlers)
- `upload_file` — upload a file via a file input

**Navigation**
- `navigate_page` — navigate to a URL
- `new_page` — open a new tab
- `close_page` — close a tab
- `list_pages` — list all open tabs
- `select_page` — switch to a specific tab
- `wait_for` — wait for a selector, text, or timeout

**Emulation**
- `emulate` — emulate a device (mobile, tablet, custom viewport/UA)
- `resize_page` — resize the browser window

**Performance**
- `performance_start_trace` — start a DevTools performance trace
- `performance_stop_trace` — stop the trace and get raw data
- `performance_analyze_insight` — analyze trace for actionable insights (uses CrUX field data)
- `take_memory_snapshot` — capture a JS heap snapshot

**Network**
- `list_network_requests` — list all network requests for the current page
- `get_network_request` — get details of a specific network request

**Debugging**
- `take_screenshot` — capture a screenshot
- `take_snapshot` — capture a DOM snapshot
- `evaluate_script` — evaluate JavaScript in the page context
- `list_console_messages` — list all console messages (with source-mapped stack traces)
- `get_console_message` — get a specific console message
- `lighthouse_audit` — run a Lighthouse audit (performance, accessibility, SEO, etc.)

## When to use

- Profiling page performance: recording traces, analyzing CPU/rendering bottlenecks
- Running Lighthouse audits for performance, accessibility, or SEO scores
- Debugging network requests, console errors, or JS runtime issues
- Automating browser interactions where Puppeteer reliability is preferred
- Connecting to your existing Chrome session (e.g. to reuse auth state)
- Taking heap memory snapshots to diagnose memory leaks

## Caveats

- Starts a new Chrome instance by default using a persistent profile at
  `~/.cache/chrome-devtools-mcp/chrome-profile-stable` on macOS/Linux
- Performance traces may send URLs to the Google CrUX API for field data;
  disable with `--no-performance-crux`
- Usage statistics are collected by default; opt out with `--no-usage-statistics`
- Exposes full browser content to MCP clients — avoid use with sensitive sessions
  unless using `--isolated`
- Requires Node.js v20.19+ and Chrome stable (current version)

## Setup

No environment variables required. Node.js and Chrome must be installed.

To verify Chrome DevTools MCP is working:
```
Check the performance of https://developers.chrome.com
```

## opencode.jsonc config

Standard (headed, persistent profile):
```jsonc
"chrome-devtools": {
  "type": "local",
  "command": ["npx", "-y", "chrome-devtools-mcp@latest"],
  "enabled": true
}
```

Headless with isolated (temporary) profile:
```jsonc
"chrome-devtools": {
  "type": "local",
  "command": ["npx", "-y", "chrome-devtools-mcp@latest", "--headless", "--isolated"],
  "enabled": true
}
```

Slim mode (3 tools only: navigate, evaluate, screenshot) — lower token usage:
```jsonc
"chrome-devtools": {
  "type": "local",
  "command": ["npx", "-y", "chrome-devtools-mcp@latest", "--slim", "--headless"],
  "enabled": true
}
```

Connect to an already-running Chrome instance (Chrome 144+, auto-connect):
```jsonc
"chrome-devtools": {
  "type": "local",
  "command": ["npx", "-y", "chrome-devtools-mcp@latest", "--autoConnect"],
  "enabled": true
}
```
Requires enabling remote debugging in Chrome at `chrome://inspect/#remote-debugging` first.

Connect to a Chrome instance started with `--remote-debugging-port`:
```jsonc
"chrome-devtools": {
  "type": "local",
  "command": ["npx", "-y", "chrome-devtools-mcp@latest", "--browser-url=http://127.0.0.1:9222"],
  "enabled": true
}
```
Start Chrome manually:
```bash
# macOS
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome \
  --remote-debugging-port=9222 \
  --user-data-dir=/tmp/chrome-debug-profile
```

No telemetry:
```jsonc
"chrome-devtools": {
  "type": "local",
  "command": [
    "npx", "-y", "chrome-devtools-mcp@latest",
    "--no-usage-statistics",
    "--no-performance-crux"
  ],
  "enabled": true
}
```
