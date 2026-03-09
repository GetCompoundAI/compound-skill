# Compound

AI-powered financial analysis. Chat with AI to analyze documents and edit Excel workbooks, Word docs, and more.

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/getcompoundai/compound-skill/main/install.sh | bash
```

Or specify a version:

```bash
curl -fsSL https://raw.githubusercontent.com/getcompoundai/compound-skill/main/install.sh | bash -s v0.1.0
```

Then authenticate:

```bash
compound login
```

## Use with OpenClaw

```bash
# Install the skill directly
git clone https://github.com/getcompoundai/compound-skill.git ~/.openclaw/skills/compound

# Verify
openclaw skills list | grep compound

# Use it
openclaw agent --message "use compound to analyze my portfolio"
```

## Use with Claude Code

1. Install the plugin (in Claude Code):

```
/plugin marketplace add getcompoundai/compound-skill
/plugin install compound@getcompoundai-compound-skill
```

The plugin automatically installs the `compound` binary on first session if not already present.

2. Authenticate:

```bash
compound login
```

3. Tell Claude: "use compound to list my workspaces"

## Update

```bash
compound update
```

## Quick start

```bash
compound login                                    # authenticate
compound workspaces create "Q4 Analysis"          # create workspace
compound files upload <workspace-id> report.xlsx  # upload files
compound ask "Summarize the report" -w <id>       # ask questions
compound artifacts download-all <id> <thread-id>  # download results
```

## Commands

| Command | Description |
|---|---|
| `compound ask "..."` | Ask a one-off question |
| `compound chat` | Start interactive chat |
| `compound workspaces list` | List workspaces |
| `compound files upload <ws> <file>` | Upload file to workspace |
| `compound artifacts download-all <ws> <thread>` | Download AI-created docs |

See `compound --help` for all commands.
