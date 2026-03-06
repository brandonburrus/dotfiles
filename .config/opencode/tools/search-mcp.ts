// import { tool } from "@opencode-ai/plugin"
// import path from "node:path"
// import fs from "node:fs/promises"
// import crypto from "node:crypto"
// import duckdb from "duckdb"
// import { Ollama } from "ollama"
//
// const CATALOG_DIR = path.join(
//   process.env.HOME ?? "~",
//   ".config/opencode/mcp",
// )
// const DB_PATH = path.join(
//   process.env.HOME ?? "~",
//   ".config/opencode/mcp-catalog.duckdb",
// )
// const EMBED_MODEL = "qwen3-embedding:4b"
//
// const ollama = new Ollama({ host: "http://localhost:11434" })
// const EMBED_DIM = 2560
//
// // ---------------------------------------------------------------------------
// // DuckDB helpers (callback API wrapped in promises)
// // ---------------------------------------------------------------------------
//
// function openDb(dbPath: string): Promise<duckdb.Database> {
//   return new Promise((resolve, reject) => {
//     const db = new duckdb.Database(dbPath, (err) => {
//       if (err) reject(err)
//       else resolve(db)
//     })
//   })
// }
//
// function dbRun(conn: duckdb.Connection, sql: string, params: unknown[] = []): Promise<void> {
//   return new Promise((resolve, reject) => {
//     conn.run(sql, ...params, (err: Error | null) => {
//       if (err) reject(err)
//       else resolve()
//     })
//   })
// }
//
// function dbAll<T = Record<string, unknown>>(
//   conn: duckdb.Connection,
//   sql: string,
//   params: unknown[] = [],
// ): Promise<T[]> {
//   return new Promise((resolve, reject) => {
//     conn.all(sql, ...params, (err: Error | null, rows: T[]) => {
//       if (err) reject(err)
//       else resolve(rows)
//     })
//   })
// }
//
// // ---------------------------------------------------------------------------
// // Cache: keyed by a SHA-256 hash of all catalog file contents combined
// // ---------------------------------------------------------------------------
//
// async function catalogHash(): Promise<string> {
//   let files: string[]
//   try {
//     files = (await fs.readdir(CATALOG_DIR)).filter((f) => f.endsWith(".md")).sort()
//   } catch {
//     return ""
//   }
//   const hash = crypto.createHash("sha256")
//   for (const f of files) {
//     const content = await fs.readFile(path.join(CATALOG_DIR, f), "utf8")
//     hash.update(f)
//     hash.update(content)
//   }
//   return hash.digest("hex")
// }
//
// interface CachedEntry {
//   name: string
//   description: string
//   when_to_use: string
//   embedding: number[]
// }
//
// // Build the inline array_value(...) literal for a FLOAT[N] column.
// // We cannot pass JS arrays as parameters due to a duckdb Node binding bug
// // that serializes them to strings.
// function floatArrayLiteral(vec: number[], dim: number): string {
//   return `array_value(${vec.join(",")})::FLOAT[${dim}]`
// }
//
// async function ensureTable(conn: duckdb.Connection): Promise<void> {
//   await dbRun(conn, `INSTALL vss`)
//   await dbRun(conn, `LOAD vss`)
//
//   await dbRun(
//     conn,
//     `CREATE TABLE IF NOT EXISTS catalog_embeddings (
//       catalog_hash  VARCHAR NOT NULL,
//       name          VARCHAR NOT NULL,
//       description   VARCHAR NOT NULL,
//       when_to_use   VARCHAR NOT NULL,
//       vec           FLOAT[${EMBED_DIM}] NOT NULL,
//       PRIMARY KEY (catalog_hash, name)
//     )`,
//   )
// }
//
// async function loadCachedEmbeddings(hash: string): Promise<CachedEntry[] | null> {
//   const db = await openDb(DB_PATH)
//   const conn = db.connect()
//   try {
//     await ensureTable(conn)
//     const rows = await dbAll<{ name: string; description: string; when_to_use: string; vec: number[] }>(
//       conn,
//       `SELECT name, description, when_to_use, vec
//        FROM catalog_embeddings
//        WHERE catalog_hash = ?`,
//       [hash],
//     )
//     if (rows.length === 0) return null
//     return rows.map((r) => ({
//       name: r.name,
//       description: r.description,
//       when_to_use: r.when_to_use,
//       embedding: Array.isArray(r.vec) ? r.vec : Object.values(r.vec as object) as number[],
//     }))
//   } finally {
//     // intentionally not calling db.close() — Bun segfaults on it; let GC handle it
//   }
// }
//
// async function saveCachedEmbeddings(hash: string, entries: CachedEntry[]): Promise<void> {
//   const db = await openDb(DB_PATH)
//   const conn = db.connect()
//   try {
//     await ensureTable(conn)
//     // Remove stale hashes to keep the DB small
//     await dbRun(conn, `DELETE FROM catalog_embeddings WHERE catalog_hash != ?`, [hash])
//     for (const e of entries) {
//       const vecLit = floatArrayLiteral(e.embedding, EMBED_DIM)
//       await dbRun(
//         conn,
//         `INSERT OR REPLACE INTO catalog_embeddings
//            (catalog_hash, name, description, when_to_use, vec)
//          VALUES (?, ?, ?, ?, ${vecLit})`,
//         [hash, e.name, e.description, e.when_to_use],
//       )
//     }
//   } finally {
//     // intentionally not calling db.close()
//   }
// }
//
// // ---------------------------------------------------------------------------
// // VSS semantic search via HNSW index
// // Returns top-k entries by cosine similarity to queryVec.
// // We build the HNSW index in-memory after loading rows (no persistence —
// // hnsw_enable_experimental_persistence has known WAL recovery issues).
// // ---------------------------------------------------------------------------
//
// async function vssSearch(
//   entries: CachedEntry[],
//   queryVec: number[],
//   topK: number,
// ): Promise<Array<{ name: string; score: number }>> {
//   const db = await openDb(":memory:")
//   const conn = db.connect()
//   try {
//     await dbRun(conn, `INSTALL vss`)
//     await dbRun(conn, `LOAD vss`)
//
//     await dbRun(
//       conn,
//       `CREATE TABLE search_vecs (
//         name  VARCHAR NOT NULL,
//         vec   FLOAT[${EMBED_DIM}] NOT NULL
//       )`,
//     )
//
//     for (const e of entries) {
//       const vecLit = floatArrayLiteral(e.embedding, EMBED_DIM)
//       await dbRun(
//         conn,
//         `INSERT INTO search_vecs (name, vec) VALUES (?, ${vecLit})`,
//         [e.name],
//       )
//     }
//
//     await dbRun(
//       conn,
//       `CREATE INDEX hnsw_idx ON search_vecs USING HNSW (vec)
//        WITH (metric = 'cosine')`,
//     )
//
//     const queryLit = floatArrayLiteral(queryVec, EMBED_DIM)
//     const rows = await dbAll<{ name: string; dist: number }>(
//       conn,
//       `SELECT name, array_cosine_distance(vec, ${queryLit}) AS dist
//        FROM search_vecs
//        ORDER BY dist
//        LIMIT ${topK}`,
//     )
//
//     // array_cosine_distance returns 0 for identical, 2 for opposite.
//     // Convert to a similarity score in [0, 1].
//     return rows.map((r) => ({ name: r.name, score: 1 - r.dist / 2 }))
//   } finally {
//     // intentionally not calling db.close()
//   }
// }
//
// // ---------------------------------------------------------------------------
// // Ollama
// // ---------------------------------------------------------------------------
//
// async function embed(texts: string[]): Promise<number[][]> {
//   const res = await ollama.embed({ model: EMBED_MODEL, input: texts })
//   return res.embeddings
// }
//
// // ---------------------------------------------------------------------------
// // Catalog parsing
// // ---------------------------------------------------------------------------
//
// function extractSection(content: string, heading: string): string {
//   const re = new RegExp(`## ${heading}\\s+([\\s\\S]*?)(?=\\n## |\\n---\\n|$)`, "i")
//   const match = content.match(re)
//   if (match) return match[1].trim()
//   const bodyMatch = content.match(/^---[\s\S]*?---\s*([\s\S]*)$/m)
//   return bodyMatch ? bodyMatch[1].trim() : content.trim()
// }
//
// function extractFrontmatterField(content: string, field: string): string {
//   const match = content.match(new RegExp(`^${field}:\\s*(.+)$`, "m"))
//   return match ? match[1].trim() : ""
// }
//
// async function readCatalog(): Promise<
//   { name: string; description: string; whenToUse: string }[]
// > {
//   let files: string[]
//   try {
//     files = (await fs.readdir(CATALOG_DIR)).filter((f) => f.endsWith(".md")).sort()
//   } catch {
//     return []
//   }
//   const entries = []
//   for (const f of files) {
//     const content = await fs.readFile(path.join(CATALOG_DIR, f), "utf8")
//     entries.push({
//       name: extractFrontmatterField(content, "name") || f.replace(".md", ""),
//       description: extractSection(content, "Description").split("\n")[0],
//       whenToUse: extractSection(content, "When to use"),
//     })
//   }
//   return entries
// }
//
// // ---------------------------------------------------------------------------
// // Result type
// // ---------------------------------------------------------------------------
//
// interface SearchResult {
//   name: string
//   score: number
//   description: string
//   install_command: string
// }
//
// // ---------------------------------------------------------------------------
// // Tool
// // ---------------------------------------------------------------------------
//
// export default tool({
//   description:
//     "Search the local MCP catalog using semantic similarity. Provide an array of primary technologies detected in the project (e.g. ['TypeScript', 'GitHub Actions', 'PostgreSQL']). Returns a ranked JSON array of matching MCP servers from the catalog. Catalog embeddings are cached in DuckDB keyed by content hash; the HNSW index is built in-memory on each run.",
//   args: {
//     technologies: {
//       type: "array",
//       items: { type: "string" },
//       description:
//         "List of primary technologies, frameworks, platforms, or services to search against (e.g. ['TypeScript', 'GitHub Actions', 'PostgreSQL', 'Sentry'])",
//     },
//     limit: {
//       type: "number",
//       description: "Maximum number of results to return (default: 5)",
//     },
//   },
//   async execute(args: { technologies: string[]; limit?: number }) {
//     const technologies: string[] = args.technologies ?? []
//     const limit = args.limit ?? 5
//
//     if (technologies.length === 0) {
//       return JSON.stringify({ error: "technologies array must not be empty" })
//     }
//
//     // 1. Compute catalog hash
//     const hash = await catalogHash()
//     if (!hash) {
//       return JSON.stringify({
//         error: `No MCP catalog entries found in ${CATALOG_DIR}. Add .md files there to build the catalog.`,
//       })
//     }
//
//     // 2. Try to load cached embeddings; generate and cache on miss
//     let cachedEntries = await loadCachedEmbeddings(hash)
//
//     if (!cachedEntries) {
//       const catalog = await readCatalog()
//       if (catalog.length === 0) {
//         return JSON.stringify({ error: `No MCP catalog entries found in ${CATALOG_DIR}.` })
//       }
//
//       let catalogEmbeddings: number[][]
//       try {
//         catalogEmbeddings = await embed(catalog.map((e) => e.whenToUse))
//       } catch (err) {
//         return JSON.stringify({
//           error: `Failed to connect to Ollama for embeddings. Make sure Ollama is running and "${EMBED_MODEL}" is available. Details: ${err}`,
//         })
//       }
//
//       cachedEntries = catalog.map((e, i) => ({
//         name: e.name,
//         description: e.description,
//         when_to_use: e.whenToUse,
//         embedding: catalogEmbeddings[i],
//       }))
//
//       await saveCachedEmbeddings(hash, cachedEntries)
//     }
//
//     // 3. Batch-embed all technology queries in a single Ollama call
//     let queryEmbeddings: number[][]
//     try {
//       queryEmbeddings = await embed(technologies)
//     } catch (err) {
//       return JSON.stringify({
//         error: `Failed to embed technologies via Ollama. Details: ${err}`,
//       })
//     }
//
//     // 4. Run VSS search for each technology, merge by keeping max score per server
//     const scoreMap = new Map<string, number>()
//     for (const queryVec of queryEmbeddings) {
//       const results = await vssSearch(cachedEntries, queryVec, cachedEntries.length)
//       for (const r of results) {
//         const prev = scoreMap.get(r.name) ?? 0
//         if (r.score > prev) scoreMap.set(r.name, r.score)
//       }
//     }
//
//     // 5. Filter by threshold, sort, apply limit
//     const THRESHOLD = 0.3
//     const results: SearchResult[] = Array.from(scoreMap.entries())
//       .filter(([, score]) => score >= THRESHOLD)
//       .sort((a, b) => b[1] - a[1])
//       .slice(0, limit)
//       .map(([name, score]) => {
//         const entry = cachedEntries!.find((e) => e.name === name)!
//         return {
//           name,
//           score: Math.round(score * 100) / 100,
//           description: entry.description,
//           install_command: `/install-mcp ${name}`,
//         }
//       })
//
//     return JSON.stringify(results)
//   },
// })
