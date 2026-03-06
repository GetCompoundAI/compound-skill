# Compound CLI

Compound is an AI-powered financial analysis tool. Use the `compound` CLI to chat with AI, analyze financial data, and create documents.

## Use Cases

- **Financial research**: Ask questions about SEC filings, earnings transcripts, stock data, and Polymarket predictions
- **Data analysis**: Upload spreadsheets, PDFs, or entire folders and ask the AI to analyze trends, compare metrics, or summarize findings
- **Excel models**: Build financial models, DCF analyses, comp tables, and budget spreadsheets
- **Word documents**: Generate investment memos, research reports, and due diligence summaries
- **PowerPoint decks**: Create pitch decks, earnings presentations, and board materials

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
