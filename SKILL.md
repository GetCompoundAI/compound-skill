---
name: compound
description: "Create professional Excel, PowerPoint, and Word documents from raw data — analyze PDFs, CSVs, SEC filings, earnings transcripts, Polymarket, and data rooms with AI"
metadata: {"openclaw": {"emoji": "🏦", "os": ["darwin", "linux"], "primaryEnv": "COMPOUND_TOKEN", "requires": {"bins": ["compound"], "env": ["COMPOUND_TOKEN"]}, "install": [{"kind": "download", "url": "https://github.com/getcompoundai/compound-skill/releases/latest/download/compound-darwin-arm64.tar.gz", "archive": "tar.gz", "os": "darwin", "arch": "arm64"}, {"kind": "download", "url": "https://github.com/getcompoundai/compound-skill/releases/latest/download/compound-darwin-x64.tar.gz", "archive": "tar.gz", "os": "darwin", "arch": "x64"}, {"kind": "download", "url": "https://github.com/getcompoundai/compound-skill/releases/latest/download/compound-linux-arm64.tar.gz", "archive": "tar.gz", "os": "linux", "arch": "arm64"}, {"kind": "download", "url": "https://github.com/getcompoundai/compound-skill/releases/latest/download/compound-linux-x64.tar.gz", "archive": "tar.gz", "os": "linux", "arch": "x64"}]}}
---

# Compound CLI

Compound turns raw data into professional work output. Upload PDFs, CSVs, spreadsheets, or entire data rooms and use AI to analyze, transform, and produce polished Excel workbooks, PowerPoint decks, and Word documents.

## Use Cases

- **Document creation**: Build professional Excel models, PowerPoint presentations, and Word reports from scratch or from uploaded data
- **Data room analysis**: Upload folders of PDFs, spreadsheets, and documents — AI reads, cross-references, and synthesizes findings
- **Data transformation**: Convert raw CSVs and PDFs into structured Excel workbooks with formatting, formulas, and charts
- **Financial research**: Query SEC filings (10-K, 10-Q, 8-K), earnings transcripts, stock data, and Polymarket predictions — no API keys needed
- **End-to-end workflow**: Go from raw data to final deliverable — upload source files, ask questions, iterate on analysis, and download polished documents

## Data Integrations

Compound has built-in access to:

- **SEC filings** — 10-K, 10-Q, 8-K, proxy statements, and more
- **Stock data** — Real-time and historical prices, fundamentals, and financial statements
- **Earnings transcripts** — Conference call transcripts with Q&A
- **Polymarket** — Prediction market data and odds

No API keys needed — just ask about a company or topic and Compound fetches the data.

## Concepts

- **Workspace**: A container for related chats and files (like a project folder). Each workspace can have uploaded files that the AI can reference.
- **Thread**: A conversation with the AI within a workspace (also called a chat). Threads can include AI-assisted artifact editing.
- **Artifact**: A document produced or edited by the AI during a chat — Excel workbooks, Word documents, PDFs, or PowerPoint files.

## Authentication

Run `compound login` to authenticate via browser. This stores a token locally.

You can also set the `COMPOUND_TOKEN` environment variable with a Firebase ID token.

## Commands

### Ask a question (one-off)

```bash
# Ask a question (auto-creates workspace and thread)
compound ask "Analyze the revenue trends in Q4"

# Ask within a specific workspace (AI can reference uploaded files)
compound ask "Summarize the report" --workspace-id <id>

# Continue an existing thread
compound ask "Follow up on that" -w <workspace-id> -t <thread-id>

# Get JSON output (NDJSON, one event per line)
compound ask "What is 2+2" --json

# Get only the final text response (no streaming, no status)
compound ask "Summarize the report" --quiet

# Download any artifacts the AI creates during the response
compound ask "Create a budget spreadsheet" -w <id> --download
```

When the AI needs clarification, it presents interactive multi-choice questions. Select an option by number or type a custom answer. The AI then continues with your response.

### Interactive chat session

```bash
# Start an interactive chat (auto-creates workspace and thread)
compound chat

# Chat within a specific workspace
compound chat -w <workspace-id>

# Resume a specific thread
compound chat -w <workspace-id> -t <thread-id>
```

### Workspaces

```bash
compound workspaces list [--json]
compound workspaces create "My Analysis" [--json]
compound workspaces share <workspace-id> <private|team|public> [--json]
```

### Threads

```bash
compound threads list <workspace-id> [--json]
compound threads create <workspace-id> --name "Q4 Analysis" [--json]
compound threads share <workspace-id> <thread-id> <private|team|public> [--json]
```

### Messages

```bash
compound messages list <workspace-id> <thread-id> [--json] [--last 5]
```

### Files (workspace-level documents)

Upload files or folders to a workspace so the AI can reference them in chats. Folder uploads preserve relative paths.

```bash
compound files list <workspace-id> [--json]
compound files upload <workspace-id> ./report.xlsx [--json]
compound files upload <workspace-id> ./my-folder/ [--json]
compound files download <workspace-id> <file-id> [-o output.xlsx]
compound files download-all <workspace-id> [-o output-dir]
```

### Artifacts (AI-created documents in threads)

Documents the AI creates or edits during a chat (Excel, Word, PDF, etc.).

```bash
compound artifacts list <workspace-id> <thread-id> [--json]
compound artifacts download <workspace-id> <thread-id> <version-id> [-o output.xlsx]
compound artifacts download-all <workspace-id> <thread-id> [-o output-dir]
```

### Sharing

Control who can access a workspace or thread.

```bash
# Make a workspace public (anyone with the link)
compound workspaces share <workspace-id> public

# Share with your team
compound workspaces share <workspace-id> team

# Make private (only you)
compound workspaces share <workspace-id> private

# Share a thread (thread can't be more visible than its workspace)
compound threads share <workspace-id> <thread-id> public
```

### Update

```bash
compound update
```

Checks for a newer version and prints the install command if one is available.

### Configuration

```bash
compound config set api-url https://ws.getcompound.ai
compound config set default-workspace <workspace-id>
compound config show
```

## Output Modes

- **Human (default)**: Streams text inline, shows agent operations as status lines on stderr
- **JSON (`--json`)**: NDJSON output — one JSON object per SSE event, easy for agents to parse
- **Quiet (`--quiet`)**: Only outputs the final text response (no streaming, no status)

## Typical Workflow

```bash
# 1. Sign in
compound login

# 2. Create a workspace and upload files (single file or entire folder)
compound workspaces create "Q4 Analysis"
compound files upload <workspace-id> earnings.xlsx
compound files upload <workspace-id> ./data-folder/

# 3. Ask questions about the files
compound ask "What were the revenue trends?" -w <workspace-id>

# 4. Download any artifacts the AI created
compound artifacts download-all <workspace-id> <thread-id>

# 5. Share the thread publicly
compound threads share <workspace-id> <thread-id> public
```

## Environment Variables

| Variable | Description |
|---|---|
| `COMPOUND_TOKEN` | Firebase ID token for authentication |
| `COMPOUND_API_URL` | API base URL (default: https://ws.getcompound.ai) |
| `COMPOUND_WORKSPACE_ID` | Default workspace ID |
