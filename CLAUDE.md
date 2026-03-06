# Compound CLI

Compound is an AI-powered financial analysis tool. Use the `compound` CLI to send messages, manage workspaces, and work with documents.

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

# Files (upload to workspace for AI to reference)
compound files list <workspace-id> [--json]
compound files upload <workspace-id> ./report.xlsx [--json]
compound files upload <workspace-id> ./my-folder/ [--json]
compound files download <workspace-id> <file-id> [-o output.xlsx]
compound files download-all <workspace-id> [-o output-dir]

# Threads
compound threads list <workspace-id> [--json]
compound threads create <workspace-id> --name "Q4 Analysis" [--json]

# Messages
compound messages list <workspace-id> <thread-id> [--json] [--last 5]

# Artifacts (AI-created documents)
compound artifacts list <workspace-id> <thread-id> [--json]
compound artifacts download <workspace-id> <thread-id> <version-id> [-o output.xlsx]
compound artifacts download-all <workspace-id> <thread-id> [-o output-dir]

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
```
