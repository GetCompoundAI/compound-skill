# Compound

AI-powered financial analysis. Chat with AI to analyze documents and edit Excel workbooks, Word docs, and more.

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/getcompoundai/openclaw/main/install.sh | bash
```

Or specify a version:

```bash
curl -fsSL https://raw.githubusercontent.com/getcompoundai/openclaw/main/install.sh | bash -s v0.1.0
```

Then authenticate:

```bash
compound login
```

## Use with OpenClaw

```bash
# Install the skill directly
git clone https://github.com/getcompoundai/openclaw.git ~/.openclaw/skills/compound

# Verify
openclaw skills list | grep compound

# Use it
openclaw agent --message "use compound to analyze my portfolio"
```

## Use with Claude Code

Add to your project's `.claude/settings.json`:

```json
{
  "permissions": {
    "allow": ["Bash(compound:*)"]
  }
}
```

Then tell Claude: "use compound to list my workspaces"

Or add this repo as a reference in your CLAUDE.md:

```markdown
See https://github.com/getcompoundai/openclaw/blob/main/CLAUDE.md for compound CLI usage.
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
