import { tool } from "@opencode-ai/plugin"
import path from "node:path"
import fs from "node:fs/promises"
import crypto from "node:crypto"
import duckdb from "duckdb"
import { Ollama } from "ollama"

const CATALOG_DIR = path.join(
  process.env.HOME ?? "~",
  ".config/opencode/mcp",
)
const DB_PATH = path.join(
  process.env.HOME ?? "~",
  ".config/opencode/mcp-catalog.duckdb",
)
const EMBED_MODEL = "qwen3-embedding:4b"

const ollama = new Ollama({ host: "http://localhost:11434" })
const EMBED_DIM = 2560

// Files/dirs to read from the project root for context
const PROJECT_SIGNALS = [
  "README.md",
  "README.mdx",
  "package.json",
  "Cargo.toml",
  "pyproject.toml",
  "go.mod",
  "composer.json",
  "Gemfile",
  ".sentry",
  "sentry.properties",
  ".github",
]

// Max chars to read from any single project file
const MAX_FILE_CHARS = 4000

// ---------------------------------------------------------------------------
// DuckDB helpers (callback API wrapped in promises)
// ---------------------------------------------------------------------------

function openDb(dbPath: string): Promise<duckdb.Database> {
  return new Promise((resolve, reject) => {
    const db = new duckdb.Database(dbPath, (err) => {
      if (err) reject(err)
      else resolve(db)
    })
  })
}

function dbRun(conn: duckdb.Connection, sql: string, params: unknown[] = []): Promise<void> {
  return new Promise((resolve, reject) => {
    conn.run(sql, ...params, (err: Error | null) => {
      if (err) reject(err)
      else resolve()
    })
  })
}

function dbAll<T = Record<string, unknown>>(
  conn: duckdb.Connection,
  sql: string,
  params: unknown[] = [],
): Promise<T[]> {
  return new Promise((resolve, reject) => {
    conn.all(sql, ...params, (err: Error | null, rows: T[]) => {
      if (err) reject(err)
      else resolve(rows)
    })
  })
}

// ---------------------------------------------------------------------------
// Cache: keyed by a SHA-256 hash of all catalog file contents combined
// ---------------------------------------------------------------------------

async function catalogHash(): Promise<string> {
  let files: string[]
  try {
    files = (await fs.readdir(CATALOG_DIR)).filter((f) => f.endsWith(".md")).sort()
  } catch {
    return ""
  }
  const hash = crypto.createHash("sha256")
  for (const f of files) {
    const content = await fs.readFile(path.join(CATALOG_DIR, f), "utf8")
    hash.update(f)
    hash.update(content)
  }
  return hash.digest("hex")
}

interface CachedEntry {
  name: string
  description: string
  when_to_use: string
  embedding: number[]
}

// Build the inline array_value(...) literal for a FLOAT[N] column.
// We cannot pass JS arrays as parameters due to a duckdb Node binding bug
// that serializes them to strings.
function floatArrayLiteral(vec: number[], dim: number): string {
  return `array_value(${vec.join(",")})::FLOAT[${dim}]`
}

async function ensureTable(conn: duckdb.Connection): Promise<void> {
  // Load VSS extension (INSTALL is a no-op if already installed)
  await dbRun(conn, `INSTALL vss`)
  await dbRun(conn, `LOAD vss`)

  await dbRun(
    conn,
    `CREATE TABLE IF NOT EXISTS catalog_embeddings (
      catalog_hash  VARCHAR NOT NULL,
      name          VARCHAR NOT NULL,
      description   VARCHAR NOT NULL,
      when_to_use   VARCHAR NOT NULL,
      vec           FLOAT[${EMBED_DIM}] NOT NULL,
      PRIMARY KEY (catalog_hash, name)
    )`,
  )
}

async function loadCachedEmbeddings(hash: string): Promise<CachedEntry[] | null> {
  const db = await openDb(DB_PATH)
  const conn = db.connect()
  try {
    await ensureTable(conn)
    const rows = await dbAll<{ name: string; description: string; when_to_use: string; vec: number[] }>(
      conn,
      `SELECT name, description, when_to_use, vec
       FROM catalog_embeddings
       WHERE catalog_hash = ?`,
      [hash],
    )
    if (rows.length === 0) return null
    return rows.map((r) => ({
      name: r.name,
      description: r.description,
      when_to_use: r.when_to_use,
      embedding: Array.isArray(r.vec) ? r.vec : Object.values(r.vec as object) as number[],
    }))
  } finally {
    // intentionally not calling db.close() — Bun segfaults on it; let GC handle it
  }
}

async function saveCachedEmbeddings(hash: string, entries: CachedEntry[]): Promise<void> {
  const db = await openDb(DB_PATH)
  const conn = db.connect()
  try {
    await ensureTable(conn)
    // Remove stale hashes to keep the DB small
    await dbRun(conn, `DELETE FROM catalog_embeddings WHERE catalog_hash != ?`, [hash])
    for (const e of entries) {
      const vecLit = floatArrayLiteral(e.embedding, EMBED_DIM)
      await dbRun(
        conn,
        `INSERT OR REPLACE INTO catalog_embeddings
           (catalog_hash, name, description, when_to_use, vec)
         VALUES (?, ?, ?, ?, ${vecLit})`,
        [hash, e.name, e.description, e.when_to_use],
      )
    }
  } finally {
    // intentionally not calling db.close()
  }
}

// ---------------------------------------------------------------------------
// VSS semantic search via HNSW index
// Returns top-k entries by cosine similarity to queryVec.
// We build the HNSW index in-memory after loading rows (no persistence —
// hnsw_enable_experimental_persistence has known WAL recovery issues).
// ---------------------------------------------------------------------------

async function vssSearch(
  entries: CachedEntry[],
  queryVec: number[],
  topK: number,
): Promise<Array<{ name: string; score: number }>> {
  // Use an in-memory DB for the HNSW index to avoid touching the persisted file
  const db = await openDb(":memory:")
  const conn = db.connect()
  try {
    await dbRun(conn, `INSTALL vss`)
    await dbRun(conn, `LOAD vss`)

    await dbRun(
      conn,
      `CREATE TABLE search_vecs (
        name  VARCHAR NOT NULL,
        vec   FLOAT[${EMBED_DIM}] NOT NULL
      )`,
    )

    for (const e of entries) {
      const vecLit = floatArrayLiteral(e.embedding, EMBED_DIM)
      await dbRun(
        conn,
        `INSERT INTO search_vecs (name, vec) VALUES (?, ${vecLit})`,
        [e.name],
      )
    }

    // Build HNSW index in-memory
    await dbRun(
      conn,
      `CREATE INDEX hnsw_idx ON search_vecs USING HNSW (vec)
       WITH (metric = 'cosine')`,
    )

    const queryLit = floatArrayLiteral(queryVec, EMBED_DIM)
    const rows = await dbAll<{ name: string; dist: number }>(
      conn,
      `SELECT name, array_cosine_distance(vec, ${queryLit}) AS dist
       FROM search_vecs
       ORDER BY dist
       LIMIT ${topK}`,
    )

    // array_cosine_distance returns 0 for identical, 2 for opposite.
    // Convert to a similarity score in [0, 1].
    return rows.map((r) => ({ name: r.name, score: 1 - r.dist / 2 }))
  } finally {
    // intentionally not calling db.close()
  }
}

// ---------------------------------------------------------------------------
// Ollama
// ---------------------------------------------------------------------------

async function embed(texts: string[]): Promise<number[][]> {
  const res = await ollama.embed({ model: EMBED_MODEL, input: texts })
  return res.embeddings
}

// ---------------------------------------------------------------------------
// Catalog parsing
// ---------------------------------------------------------------------------

function extractSection(content: string, heading: string): string {
  const re = new RegExp(`## ${heading}\\s+([\\s\\S]*?)(?=\\n## |\\n---\\n|$)`, "i")
  const match = content.match(re)
  if (match) return match[1].trim()
  const bodyMatch = content.match(/^---[\s\S]*?---\s*([\s\S]*)$/m)
  return bodyMatch ? bodyMatch[1].trim() : content.trim()
}

function extractFrontmatterField(content: string, field: string): string {
  const match = content.match(new RegExp(`^${field}:\\s*(.+)$`, "m"))
  return match ? match[1].trim() : ""
}

async function readCatalog(): Promise<
  { name: string; description: string; whenToUse: string }[]
> {
  let files: string[]
  try {
    files = (await fs.readdir(CATALOG_DIR)).filter((f) => f.endsWith(".md")).sort()
  } catch {
    return []
  }
  const entries = []
  for (const f of files) {
    const content = await fs.readFile(path.join(CATALOG_DIR, f), "utf8")
    entries.push({
      name: extractFrontmatterField(content, "name") || f.replace(".md", ""),
      description: extractSection(content, "Description").split("\n")[0],
      whenToUse: extractSection(content, "When to use"),
    })
  }
  return entries
}

// ---------------------------------------------------------------------------
// Project context
// ---------------------------------------------------------------------------

async function readProjectContext(worktree: string): Promise<string> {
  const parts: string[] = []
  for (const signal of PROJECT_SIGNALS) {
    const fullPath = path.join(worktree, signal)
    try {
      const stat = await fs.stat(fullPath)
      if (stat.isDirectory()) {
        parts.push(`[directory present: ${signal}]`)
      } else {
        const text = await fs.readFile(fullPath, "utf8")
        parts.push(`[${signal}]\n${text.slice(0, MAX_FILE_CHARS)}`)
      }
    } catch {
      // not present, skip
    }
  }
  return parts.join("\n\n")
}

async function readInstalledMCPs(worktree: string): Promise<Set<string>> {
  const configPath = path.join(worktree, ".opencode/opencode.jsonc")
  try {
    const text = await fs.readFile(configPath, "utf8")
    const stripped = text.replace(/\/\/.*$/gm, "").replace(/,\s*([}\]])/g, "$1")
    const parsed = JSON.parse(stripped)
    return new Set(Object.keys(parsed?.mcp ?? {}))
  } catch {
    return new Set()
  }
}

// ---------------------------------------------------------------------------
// Tool
// ---------------------------------------------------------------------------

export default tool({
  description:
    "Analyze the current project and recommend MCP servers from the local catalog using semantic similarity. Embeddings are cached in a local DuckDB file (FLOAT[2560]) keyed by catalog content hash. Similarity search uses a DuckDB VSS HNSW index built in-memory on each run. Returns a ranked list of relevant servers with install commands.",
  args: {},
  async execute(_args, context) {
    const worktree = context.worktree ?? context.directory

    // 1. Compute catalog hash
    const hash = await catalogHash()
    if (!hash) {
      return `No MCP catalog entries found in ${CATALOG_DIR}. Add .md files there to build the catalog.`
    }

    // 2. Try to load cached embeddings
    let cachedEntries = await loadCachedEmbeddings(hash)
    let cacheUsed = true

    if (!cachedEntries) {
      // Cache miss — embed catalog and store
      cacheUsed = false
      const catalog = await readCatalog()
      if (catalog.length === 0) {
        return `No MCP catalog entries found in ${CATALOG_DIR}.`
      }

      let catalogEmbeddings: number[][]
      try {
        catalogEmbeddings = await embed(catalog.map((e) => e.whenToUse))
      } catch (err) {
        return `Failed to connect to Ollama for embeddings. Make sure Ollama is running and "${EMBED_MODEL}" is available.\n\nError: ${err}`
      }

      cachedEntries = catalog.map((e, i) => ({
        name: e.name,
        description: e.description,
        when_to_use: e.whenToUse,
        embedding: catalogEmbeddings[i],
      }))

      await saveCachedEmbeddings(hash, cachedEntries)
    }

    // 3. Read project context and embed it (always fresh — project changes often)
    const projectContext = await readProjectContext(worktree)
    if (!projectContext.trim()) {
      return "Could not read any project signals (no README, package.json, etc. found at project root)."
    }

    let projectEmbedding: number[]
    try {
      ;[projectEmbedding] = await embed([projectContext])
    } catch (err) {
      return `Failed to embed project context via Ollama.\n\nError: ${err}`
    }

    // 4. Check already-installed MCPs
    const installed = await readInstalledMCPs(worktree)

    // 5. Score and rank via VSS HNSW in-memory index
    const allResults = await vssSearch(cachedEntries, projectEmbedding, cachedEntries.length)

    // 6. Format output
    const threshold = 0.3
    const recommendations = allResults.filter(
      (r) => !installed.has(r.name) && r.score >= threshold,
    )
    const alreadyInstalledList = allResults.filter((r) => installed.has(r.name))

    const lines: string[] = []
    const cacheNote = cacheUsed
      ? "_Catalog embeddings loaded from cache (DuckDB VSS)._"
      : "_Catalog embeddings generated and cached for next run (DuckDB VSS)._"
    lines.push(cacheNote, "")

    if (recommendations.length === 0) {
      lines.push("No additional MCP servers from the catalog seem relevant to this project.")
    } else {
      lines.push("### Recommended MCP servers for this project\n")
      for (const r of recommendations) {
        const entry = cachedEntries.find((e) => e.name === r.name)!
        const pct = Math.round(r.score * 100)
        lines.push(`**\`${r.name}\`** _(${pct}% match)_`)
        if (entry.description) lines.push(`> ${entry.description}`)
        lines.push(`> Install: \`/install-mcp ${r.name}\``)
        lines.push("")
      }
    }

    if (alreadyInstalledList.length > 0) {
      lines.push(
        `_Already installed: ${alreadyInstalledList.map((r) => `\`${r.name}\``).join(", ")}_`,
      )
    }

    return lines.join("\n")
  },
})
