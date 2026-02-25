---
name: aws-document-loader
type: local
command: ["uvx", "awslabs.document-loader-mcp-server@latest"]
requires_env: []
optional_env:
  - FASTMCP_LOG_LEVEL
env:
  FASTMCP_LOG_LEVEL: "ERROR"
---

## Description

MCP server for document parsing and content extraction. Supports reading and extracting text/content from PDF, Word (DOCX/DOC), Excel (XLSX/XLS), PowerPoint (PPTX/PPT), and image files (PNG, JPG, GIF, BMP, TIFF, WEBP).

## Tools provided

- `read_document` — Extract content from document files. Accepts `file_path` and `file_type` (`pdf`, `docx`, `doc`, `xlsx`, `xls`, `pptx`, `ppt`). Uses `pdfplumber` for PDFs and `markitdown` for Office formats, returning content as markdown.
- `read_image` — Load image files (PNG, JPG, GIF, BMP, TIFF, WEBP) for LLM viewing and analysis.

## When to use

- Parsing PDFs, Word documents, spreadsheets, or presentations to extract their text content for analysis or summarization.
- Loading images for visual inspection or description by an LLM.
- Any task that requires reading local files in non-text formats before processing them further.

## Caveats

- Requires `uv` and Python 3.10+ installed locally.
- File paths must be accessible on the local filesystem where the server runs.
- Large documents may produce very long outputs; consider chunking or summarizing downstream.

## Setup

1. Install `uv`: https://docs.astral.sh/uv/getting-started/installation/
2. Install Python 3.10+: `uv python install 3.10`
3. No AWS credentials or additional configuration required.

## opencode.jsonc config

```jsonc
"aws-document-loader": {
  "command": "uvx",
  "args": ["awslabs.document-loader-mcp-server@latest"],
  "env": {
    "FASTMCP_LOG_LEVEL": "ERROR"
  },
  "disabled": false,
  "autoApprove": []
}
```
