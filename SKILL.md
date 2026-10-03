---
name: compound
description: "Create professional Excel, PowerPoint, and Word documents from raw data — analyze PDFs, CSVs, SEC filings, earnings transcripts, Polymarket, and data rooms with AI"
metadata:
  {
    "openclaw":
      {
        "emoji": "🏦",
        "os": ["darwin", "linux"],
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
- **End-to-end workflow**: Go from raw data to final deliverable — upload source files, message the agent, review its tasks and proposals, and download polished documents

## Data Integrations

Compound has built-in access to:

- **SEC filings** — 10-K, 10-Q, 8-K, proxy statements, and more
- **Stock data** — Daily (end-of-day) and historical prices, fundamentals, and financial statements
- **Earnings transcripts** — Conference call transcripts with Q&A
- **Polymarket** — Prediction market data and odds

No API keys needed — message the agent about a company or topic and it fetches the data.

## Concepts

- **Agent**: Your AI agent. It holds one conversation with you, keeps a list of tasks, asks for approval through proposals, and reads and writes the files of its drive.
- **Drive**: The agent's files (like a project folder). Each agent has exactly one drive, and the agent id is the drive id, so every drive operation (files, sharing, delete) is a `compound agent` command.
- **Artifact**: A document the agent produces or edits — Excel workbooks, Word documents, PDFs, or PowerPoint files. It is stored as a file in the drive.

## Authentication

Run `compound login` to authenticate via browser — the primary path. It stores credentials locally and auto-refreshes them, so it keeps working indefinitely. **`compound login` requires an interactive terminal**: it opens a browser and reads a code you paste back. In a non-interactive context (an agent, CI, or any non-TTY shell) it fails fast instead of hanging — ask the user to run `compound login` in their own terminal.

## Commands

### Agent

Your agent is one long-running conversation: you send it a message, it picks
the work up and keeps going, opening subagents as it needs them. Every agent
command is under `compound agent`. Name an agent before the subcommand
(`compound agent <agent-id> tasks`, the id in `/agent/<agent-id>` in the app);
without one, the command works on your own agent.

```bash
# Your agents
compound agent list [--json]
compound agent new "My Analysis" [--json]
compound agent <agent-id> delete [--force] [--json]   # moves its drive to the recycle bin (restorable for 30 days); prompts unless --force

# One view: what needs you (questions, proposed tasks and proposals), what is running or paused, the last message
compound agent status [--json]

# Say something to your agent. It starts working on it right away.
compound agent say "check the revenue model for broken links"

# The conversation so far. Under a message that cites sources, each source
# prints as `[N] <name> — <Compound link>`, or `[N] <key>` when it cannot be resolved.
compound agent messages [-n 20] [--json]

# What it has been doing. --follow keeps the stream open and prints ops live;
# --raw prints every stream frame, not only activity.
compound agent activity [-n 50] [--json]
compound agent activity --follow [--raw] [--json]

# The work it is holding. States: proposed, running, needs_input, paused, completed, archived
compound agent tasks [-s needs_input running] [-n 50] [--json]

# One task: show it, open a new one, move it, or reply on it
compound agent task <number> [--json]
compound agent task new "Q3 variance memo" [-m "<body markdown>"] [--json]
compound agent task <number> set <state> [--json]
compound agent task <number> reply "use the Q3 file" [--answers <message-id>] [--step <n>]
```

`task <number> set <state>` reads the task's current state and makes the move
that gets it there:

| set to      | from                                       | does                          |
| ----------- | ------------------------------------------ | ----------------------------- |
| `running`   | proposed                                   | accept it and run it now      |
| `running`   | paused                                     | resume it                     |
| `scheduled` | proposed                                   | accept it onto its schedule   |
| `paused`    | running, needs_input                       | pause it                      |
| `archived`  | proposed, running, needs_input, paused, completed | archive it             |
| `completed` | archived                                   | unarchive it                  |
| `dismissed` | proposed                                   | turn it down; it is deleted   |

Any other move fails and names the states the task can be set to. On `reply`,
`--answers` names the question the agent asked (a message id from
`agent messages --json`) and `--step` names the workflow step.

```bash
# Proposals: changes the agent asks you to approve
compound agent proposals [--json]
compound agent proposal <proposal-id> accept|decline [--json]

# What the agent may use; change with <capability>=on|off
# (org_conventions, email, connectors, proposals, questions, web, company_data, prediction_markets)
compound agent settings [--json]
compound agent settings web=off email=on

# A citation's saved source and its resolved target, as JSON, by the key in a
# cited file, a message or a ?cite=<key> link
compound agent citation <key>
```

### Files

Upload files or folders so the agent can read them; a folder upload keeps its
relative paths. A downloaded docx or pptx has each citation linked to Compound;
a downloaded xlsx has a note on each cited cell naming its sources, with a
Compound link to each. A file the server cannot link downloads as stored.

```bash
compound agent files [--json]                         # list
compound agent files upload ./report.xlsx ./data-folder/ [--json]
compound agent files download <file-id> [-o out.xlsx]  # one id: -o is the file to write
compound agent files download <file-id> <file-id> [-o out-dir]
compound agent files download --all [-o out-dir]       # several ids or --all: -o is a folder; each file keeps its folder
```

### Sharing

Only the agent's owner can list or change its sharing.

```bash
compound agent share [--json]                          # who has access
compound agent share --public                          # turn on the read-only public link
compound agent share --team [--role read|write]        # your team; default role write
compound agent share --user alice@example.com [--role read|write]   # default role read
compound agent unshare --public | --team | --user alice@example.com
```

### Moved commands

The top-level `compound drives` and `compound files` commands, and the
`agent run|plan|dismiss|pause|resume|archive|unarchive|comment|accept|decline|watch`
verbs, are gone. Running one prints the command that replaces it.

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

- **Human (default)**: Tables and one-line summaries
- **JSON (`--json`)**: NDJSON output — one JSON object per line, easy for agents to parse

## Typical Workflow

```bash
# 1. Sign in
compound login

# 2. Upload files to your agent (single file or entire folder)
compound agent files upload earnings.xlsx
compound agent files upload ./data-folder/

# 3. Ask the agent for the work
compound agent say "What were the revenue trends? Build a summary workbook."

# 4. Follow what it does, and read its replies
compound agent activity --follow
compound agent messages

# 5. See what needs you, then answer the task or accept the proposal
compound agent status
compound agent task <number> reply "use the Q3 file"
compound agent proposal <proposal-id> accept

# 6. Download the files it created
compound agent files
compound agent files download --all -o ./out
```

## Environment Variables

| Variable            | Description                                       |
| ------------------- | ------------------------------------------------- |
| `COMPOUND_API_URL`  | API base URL (default: https://ws.getcompound.ai) |
| `COMPOUND_DRIVE_ID` | Default drive ID                                  |
