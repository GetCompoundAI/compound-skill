# Compound CLI

Compound turns raw data into professional work output. Upload PDFs, CSVs, spreadsheets, or entire data rooms and use AI to analyze, transform, and produce polished Excel workbooks, PowerPoint decks, and Word documents.

## Use Cases

- **Document creation**: Build professional Excel models, PowerPoint presentations, and Word reports from scratch or from uploaded data
- **Data room analysis**: Upload folders of PDFs, spreadsheets, and documents — AI reads, cross-references, and synthesizes findings
- **Data transformation**: Convert raw CSVs and PDFs into structured Excel workbooks with formatting, formulas, and charts
- **Financial research**: Query SEC filings (10-K, 10-Q, 8-K), earnings transcripts, stock data, and Polymarket predictions — no API keys needed
- **End-to-end workflow**: Go from raw data to final deliverable — upload source files, ask questions, iterate on analysis, and download polished documents

## Data Integrations

Compound has built-in access to SEC filings, stock data, earnings transcripts, and Polymarket — no API keys needed.

## Authentication

Run `compound login` to authenticate via browser, or set the `COMPOUND_TOKEN` environment variable.

## Commands

```bash
# Ask a question (auto-creates workspace and thread)
compound ask "Analyze the revenue trends in Q4"

# Ask within a specific workspace (AI can reference uploaded files)
compound ask "Summarize the report" --workspace-id <id>

# Continue an existing thread
compound ask "Follow up on that" -w <workspace-id> -t <thread-id>

# Get only the final text response
compound ask "Summarize the report" --quiet

# Download any artifacts the AI creates
compound ask "Create a budget spreadsheet" -w <id> --download

# Interactive chat session
compound chat
compound chat -w <workspace-id>

# Workspaces
compound workspaces list [--json]
compound workspaces create "My Analysis" [--json]
compound workspaces share <workspace-id> <private|team|public> [--json]

# Files (upload to workspace for AI to reference)
compound files list <workspace-id> [--json]
compound files upload <workspace-id> ./report.xlsx [--json]
compound files upload <workspace-id> ./my-folder/ [--json]
compound files download <workspace-id> <file-id> [-o output.xlsx]
compound files download-all <workspace-id> [-o output-dir]

# Threads
compound threads list <workspace-id> [--json]
compound threads create <workspace-id> --name "Q4 Analysis" [--json]
compound threads share <workspace-id> <thread-id> <private|team|public> [--json]

# Messages
compound messages list <workspace-id> <thread-id> [--json] [--last 5]

# Artifacts (AI-created documents)
compound artifacts list <workspace-id> <thread-id> [--json]
compound artifacts download <workspace-id> <thread-id> <version-id> [-o output.xlsx]
compound artifacts download-all <workspace-id> <thread-id> [-o output-dir]

# Sharing
compound workspaces share <workspace-id> public    # anyone with the link
compound workspaces share <workspace-id> team      # team members
compound workspaces share <workspace-id> private   # only you
compound threads share <workspace-id> <thread-id> public

# Update
compound update

# Configuration
compound config set api-url https://ws.getcompound.ai
compound config set default-workspace <workspace-id>
compound config show
```

## Output Modes

- **Human (default)**: Streams text inline, shows agent operations as status lines
- **JSON (`--json`)**: NDJSON output, one JSON object per SSE event
- **Quiet (`--quiet`)**: Only the final text response

## Typical Workflow

```bash
compound login
compound workspaces create "Q4 Analysis"
compound files upload <workspace-id> earnings.xlsx
compound ask "What were the revenue trends?" -w <workspace-id>
compound artifacts download-all <workspace-id> <thread-id>
compound threads share <workspace-id> <thread-id> public
```
