---
name: compound
description: "Create professional Excel, PowerPoint, and Word documents from raw data — analyze PDFs, CSVs, SEC filings, earnings transcripts, Polymarket, and data rooms with AI"
metadata:
  {
    "openclaw":
      {
        "emoji": "🏦",
        "os": ["darwin", "linux"],
        "primaryEnv": "COMPOUND_TOKEN",
        "requires": { "bins": ["compound"] },
        "install":
          [
            {
              "kind": "download",
              "url": "https://github.com/getcompoundai/compound-skill/releases/latest/download/compound-darwin-arm64.tar.gz",
              "archive": "tar.gz",
              "os": "darwin",
              "arch": "arm64",
            },
            {
              "kind": "download",
              "url": "https://github.com/getcompoundai/compound-skill/releases/latest/download/compound-darwin-x64.tar.gz",
              "archive": "tar.gz",
              "os": "darwin",
              "arch": "x64",
            },
            {
              "kind": "download",
              "url": "https://github.com/getcompoundai/compound-skill/releases/latest/download/compound-linux-arm64.tar.gz",
              "archive": "tar.gz",
              "os": "linux",
              "arch": "arm64",
            },
            {
              "kind": "download",
              "url": "https://github.com/getcompoundai/compound-skill/releases/latest/download/compound-linux-x64.tar.gz",
              "archive": "tar.gz",
              "os": "linux",
              "arch": "x64",
            },
          ],
      },
  }
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

- **Drive**: A container for related chats and files (like a project folder). Each drive can have uploaded files that the AI can reference.
- **Chat**: A conversation with the AI within a drive. Chats can include AI-assisted artifact editing.
- **Artifact**: A document produced or edited by the AI during a chat — Excel workbooks, Word documents, PDFs, or PowerPoint files.

## Authentication

Run `compound login` to authenticate via browser — the primary path. It stores credentials locally and auto-refreshes them, so it keeps working indefinitely.

Alternatively, set the `COMPOUND_TOKEN` environment variable (a Firebase ID token) as an override for environments that inject credentials. An expired `COMPOUND_TOKEN` is ignored in favor of the stored login.

## Commands

### Ask a question (one-off)

```bash
# Ask a question — without --drive-id, the new chat is created in
# your default "My Drive" (matching the web app's new-chat default).
# A new chat is created automatically.
compound ask "Analyze the revenue trends in Q4"

# Ask within a specific drive (AI can reference uploaded files in that drive)
compound ask "Summarize the report" --drive-id <id>

# Continue an existing chat
compound ask "Follow up on that" -w <drive-id> -t <chat-id>

# Get JSON output (NDJSON, one event per line)
compound ask "What is 2+2" --json

# Get only the final text response (no streaming, no status)
compound ask "Summarize the report" --quiet

# Download any artifacts the AI creates during the response
compound ask "Create a budget spreadsheet" -w <id> --download

# Restrict which files the AI can read (regex on filenames)
compound ask "Summarize inputs" -w <id> --readable-pattern "^input/"

# Restrict which paths the AI can write to (regex on filenames)
compound ask "Create output" -w <id> --writable-pattern "^output/"
```

When the AI needs clarification, it presents interactive multi-choice questions. Select an option by number or type a custom answer. The AI then continues with your response.

### Interactive chat session

```bash
# Start an interactive chat (auto-creates drive and chat)
compound chat

# Chat within a specific drive
compound chat -w <drive-id>

# Resume a specific chat
compound chat -w <drive-id> -t <chat-id>
```

### Drives

```bash
compound drives list [--json]
compound drives create "My Analysis" [--json]
compound drives publish <drive-id> [--json]                                          # turn on public link
compound drives unpublish <drive-id> [--json]                                        # turn off public link
compound drives share <drive-id> --team [--role read|write] [--json]                 # share with caller's team
compound drives share <drive-id> --user <email> [--role read|write] [--json]         # share with a specific user
compound drives unshare <drive-id> --team [--json]
compound drives unshare <drive-id> --user <email> [--json]
compound drives delete <drive-id> [--force] [--json]                                 # moves the drive to the recycle bin (restorable for 30 days); prompts unless --force
```

### Chats

```bash
compound chats list [drive-id] [--limit 20] [--json]   # omit drive-id for recent chats across all drives
compound chats create <drive-id> --name "Q4 Analysis" [--json]
compound chats share <drive-id> <chat-id> [--json]   # creates a public snapshot
compound chats delete <drive-id> <chat-id> [--force] [--json]   # prompts unless --force
```

### Messages

```bash
compound messages list <drive-id> <chat-id> [--json] [--last 5]
```

### Files (drive-level documents)

Upload files or folders to a drive so the AI can reference them in chats. Folder uploads preserve relative paths.

```bash
compound files list <drive-id> [--json]
compound files upload <drive-id> ./report.xlsx [--json]
compound files upload <drive-id> ./my-folder/ [--json]
compound files download <drive-id> <file-id> [-o output.xlsx]
compound files download-all <drive-id> [-o output-dir]
```

### Artifacts (AI-created documents in chats)

Documents the AI creates or edits during a chat (Excel, Word, PDF, etc.).

```bash
compound artifacts list <drive-id> <chat-id> [--json]
compound artifacts download <drive-id> <chat-id> <file-id> [-o output.xlsx]
compound artifacts download-all <drive-id> <chat-id> [-o output-dir]
```

### Sharing

Control who can access a drive or chat. Drive sharing is split into two operations on the underlying share-entries collection: the public link (anyone with the URL) is a single bit toggled by `publish`/`unpublish`, and per-principal grants (team and individual users) are managed via `share`/`unshare`.

```bash
# Public link (anyone with the URL)
compound drives publish <drive-id>
compound drives unpublish <drive-id>

# Per-principal grants (default role: write for --team, read for --user)
compound drives share <drive-id> --team
compound drives share <drive-id> --user alice@example.com
compound drives share <drive-id> --user alice@example.com --role write

# Remove a grant
compound drives unshare <drive-id> --team
compound drives unshare <drive-id> --user alice@example.com

# Share a chat (creates a public snapshot)
compound chats share <drive-id> <chat-id>
```

### Scheduled Tasks

```bash
# List upcoming scheduled work: recurring schedules + one-time tasks still
# `pending` or `in_progress`.
compound tasks list [--json]

# Create a one-time task
compound tasks create -w <drive-id> --question "Summarize AAPL news" --scheduled-for 2026-04-01T09:00:00 [--timezone America/New_York]

# Create a recurring schedule
compound tasks create -w <drive-id> --question "Weekly report" --recurring --cron "0 9 * * MON-FRI" [--name "Weekday report"] [--timezone America/New_York]

# Update a recurring schedule (cron, name, timezone, pause/resume)
compound tasks update <id> --cron "0 10 * * *"
compound tasks update <id> --pause
compound tasks update <id> --resume

# Delete a scheduled task or recurring schedule
compound tasks delete <id>

# View past runs. Without an id, a flat feed across every schedule and one-time
# task. With an id, only runs for that recurring schedule.
compound tasks history [id] [--json]
```

### Update

```bash
compound update
```

Checks for a newer version and prints the install command if one is available.

### Identity

```bash
compound whoami
```

Prints the signed-in user's email and user-id.

### Configuration

```bash
compound config set api-url https://ws.getcompound.ai
compound config set default-drive <drive-id>
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

# 2. Create a drive and upload files (single file or entire folder)
compound drives create "Q4 Analysis"
compound files upload <drive-id> earnings.xlsx
compound files upload <drive-id> ./data-folder/

# 3. Ask questions about the files
compound ask "What were the revenue trends?" -w <drive-id>

# 4. Download any artifacts the AI created
compound artifacts download-all <drive-id> <chat-id>

# 5. Share the chat publicly
compound chats share <drive-id> <chat-id>
```

## Environment Variables

| Variable            | Description                                       |
| ------------------- | ------------------------------------------------- |
| `COMPOUND_TOKEN`    | Firebase ID token for authentication              |
| `COMPOUND_API_URL`  | API base URL (default: https://ws.getcompound.ai) |
| `COMPOUND_DRIVE_ID` | Default drive ID                                  |
