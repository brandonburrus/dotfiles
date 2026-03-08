---
name: cog-mcp-local-cli-install
keywords:
  - cog
  - mcp
  - bun
  - bun link
  - cli
  - executable
  - local install
  - shebang
  - bin field
  - package.json
  - fastmcp
  - stdio
  - local binary
description: >-
  How to install the cog MCP server as a local CLI executable using bun link, so
  it can be run as `cog` instead of `bun --cwd /path/to/cog src/mcp.ts`. Covers
  the shebang, bin field, and bun link steps.
---
## Making the `cog` MCP server a local CLI executable (bun link approach)

### Project context
- Project: `/Users/brandon/cog`
- Runtime: Bun
- Entry point: `src/mcp.ts` (FastMCP server over stdio)
- Goal: Run `cog` on the command line instead of `bun --cwd /path/to/cog src/mcp.ts`

### Steps taken

1. **Add shebang to `src/mcp.ts`** — first line must be:
   ```
   #!/usr/bin/env bun
   ```

2. **Add `bin` field to `package.json`**:
   ```json
   "bin": {
     "cog": "src/mcp.ts"
   }
   ```

3. **Run `bun link`** in the project root:
   ```
   cd /Users/brandon/cog && bun link
   ```
   This installs a global symlink at `~/.bun/bin/cog` pointing to `src/mcp.ts`.

### Result
- `which cog` → `/Users/brandon/.bun/bin/cog`
- Running `cog` is now equivalent to `bun /Users/brandon/cog/src/mcp.ts`
- Changes to source take effect immediately — no rebuild required
- `.env` file is still loaded at runtime from the project directory (env vars are not embedded)

### Alternative: self-contained binary
If a portable binary is needed instead:
- Build: `bun build src/mcp.ts --outfile dist/cog --target=bun --compile`
- Add `"bin": { "cog": "dist/cog" }` to `package.json`
- Then `bun link` or manually copy `dist/cog` to `$PATH`
- Requires rebuild after source changes
