---
name: ollama-qwen3-embedding-pinecone-local-setup
keywords:
  - ollama
  - qwen3-embedding
  - pinecone
  - docker
  - embeddings
  - vector-db
  - local-dev
  - setup
description: >-
  Step-by-step instructions for setting up Ollama with the qwen3-embedding:8b
  model and connecting it to a local Pinecone emulator running in Docker,
  including dimension configuration and environment setup.
---
# Ollama + qwen3-embedding:8b + Local Pinecone Setup

## Overview

`qwen3-embedding:8b` is an Ollama embedding model that produces 4096-dimensional vectors. The local Pinecone Docker emulator must be configured with a matching dimension at container creation time — it cannot be changed without recreating the container.

## 1. Install and start Ollama

```sh
# macOS
brew install ollama
ollama serve
```

## 2. Pull the embedding model

```sh
ollama pull qwen3-embedding:8b
```

Verify it works:

```sh
ollama embeddings qwen3-embedding:8b "test"
```

The response will contain a 4096-element vector.

## 3. Start the local Pinecone emulator

The `DIMENSION` env var must match the model output (4096 for `qwen3-embedding:8b`). This is set once at container creation — to change it you must stop, remove, and recreate the container.

```sh
docker run -d \
  --name pinecone \
  -p 5081-6000:5081-6000 \
  -e PORT=5081 \
  -e PINECONE_HOST=localhost \
  -e DIMENSION=4096 \
  pinecone:latest
```

To recreate after a dimension change:

```sh
docker stop pinecone && docker rm pinecone
# then re-run the docker run command above
```

## 4. Connect via the Pinecone SDK

The local emulator is a **data-plane only** emulator — it has no control plane (`/indexes` API). Do NOT use `PINECONE_CONTROLLER_HOST` or rely on index name resolution. Instead, pass the host URL directly:

```ts
import { Pinecone } from '@pinecone-database/pinecone'

const pc = new Pinecone({ apiKey: 'pclocal' })
const index = pc.Index('my-index', 'http://localhost:5081')
```

Set `PINECONE_API_KEY=pclocal` in your `.env` (any non-empty string works locally).

## 5. Generate embeddings with Ollama

```ts
import { Ollama } from 'ollama'

const ollama = new Ollama({ host: 'http://localhost:11434' })
const { embedding } = await ollama.embeddings({
  model: 'qwen3-embedding:8b',
  prompt: 'text to embed',
})
// embedding is number[] with length 4096
```

## Key facts

- Model output dimension: **4096**
- Pinecone `DIMENSION` env var must equal **4096**
- Local Pinecone API key: any non-empty string (convention: `pclocal`)
- Ollama default host: `http://localhost:11434`
- Local Pinecone default port: `5081`
- The emulator is single-index and data-plane only — no index creation API
