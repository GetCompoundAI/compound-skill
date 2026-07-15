# Compound

Turn raw data into professional documents. Upload PDFs, CSVs, spreadsheets, or data rooms and use AI to analyze, transform, and produce polished Excel workbooks, PowerPoint decks, and Word documents.

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/getcompoundai/compound-skill/main/install.sh | bash
```

Or specify a version:

```bash
curl -fsSL https://raw.githubusercontent.com/getcompoundai/compound-skill/main/install.sh | bash -s v0.4.215
```

Then authenticate:

```bash
compound login
```

`login` opens a browser sign-in page and prompts you to paste a code back, so it must run in an interactive terminal.

## Quick start

```bash
compound login                                    # authenticate
compound drives create "Q4 Analysis"              # create drive
compound files upload <drive-id> report.xlsx      # upload files
compound ask "Summarize the report" -w <id>       # ask questions
compound artifacts download-all <id> <chat-id>    # download results
```

## Commands

| Command | Description |
|---|---|
| `compound ask "..."` | Ask a one-off question |
| `compound chat` | Start interactive chat |
| `compound drives list` | List drives |
| `compound files upload <drive> <file>` | Upload file to drive |
| `compound artifacts download-all <drive> <chat>` | Download AI-created docs |

See `compound --help` for all commands.

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

3. Tell Claude: "use compound to list my drives"

## Use standalone (scripts, CI, your own agents)

The `compound` binary is self-contained, so anything that can run a command can use it: try it in the terminal or with your own agent framework. Install it with the script above, or download the archive for your platform (`linux-x64`, `linux-arm64`, `darwin-x64`, `darwin-arm64`) from the [releases page](https://github.com/getcompoundai/compound-skill/releases/latest).

`compound login` stores credentials in `~/.compound/config.json` and refreshes them automatically. Where an interactive login isn't possible, pass a token directly instead:

```bash
export COMPOUND_TOKEN=<token>    # takes precedence over the stored login
export COMPOUND_DRIVE_ID=<id>    # optional: default drive for commands
```

For machine-readable output, list/upload commands take `--json`, and `ask` can stream events or reduce to plain text:

```bash
compound drives list --json      # JSON
compound ask "..." --json        # NDJSON, one event per line
compound ask "..." --quiet       # final text only
```

A scripted pipeline — upload data, analyze, collect the produced documents:

```bash
drive=$(compound drives create "Nightly Report" --json | jq -r '.id')
compound files upload "$drive" ./data/
compound ask "Build a summary workbook from the uploaded data" -w "$drive" --quiet -d
```

`ask` prints the drive ID, chat ID, and a shareable URL to stderr, and `-d` downloads any documents the AI created to the current directory (or fetch them later with `compound artifacts download-all <drive-id> <chat-id>`).

## Update

```bash
compound update
```
