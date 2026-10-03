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
compound agent files upload report.xlsx           # upload files to your agent
compound agent say "Summarize the report"         # message your agent
compound agent messages                           # read its replies
compound agent files download <file-id>           # download results
```

## Commands

| Command | Description |
|---|---|
| `compound agent say "..."` | Send a message to your agent |
| `compound agent messages` | Show the agent's conversation |
| `compound agent status` | What needs you (questions, proposed tasks, proposals), what is running |
| `compound agent tasks` | Show the tasks the agent is holding |
| `compound agent task <n> set <state>` | Run, pause, archive or dismiss a task |
| `compound agent files` | List the agent's files |
| `compound agent files upload <paths...>` | Upload files or folders to the agent |
| `compound agent list` | List your agents |

See `compound --help` for all commands.

## Use with OpenClaw

```bash
# Install the skill via OpenClaw's skill installer
openclaw skills install git:getcompoundai/compound-skill

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

Then restart Claude Code. The plugin installs the `compound` binary on session start, so it needs a fresh session to run.

2. Authenticate:

```bash
compound login
```

3. Tell Claude: "use compound to list my agents"

## Use standalone (scripts, CI, your own agents)

The `compound` binary is self-contained, so anything that can run a command can use it: try it in the terminal or with your own agent framework. Install it with the script above, or download the archive for your platform (`linux-x64`, `linux-arm64`, `darwin-x64`, `darwin-arm64`) from the [releases page](https://github.com/getcompoundai/compound-skill/releases/latest).

`compound login` stores credentials in `~/.compound/config.json` and refreshes them automatically, so a single interactive login keeps scripts and agents authenticated across sessions.

```bash
export COMPOUND_DRIVE_ID=<id>    # optional: default agent for commands
```

For machine-readable output, list, upload and agent commands take `--json` and print NDJSON, one object per line:

```bash
compound agent list --json
compound agent messages --json
compound agent activity --follow --json
```

A scripted pipeline — upload data, analyze, collect the produced documents:

```bash
agent=$(compound agent new "Nightly Report" --json | jq -r '.id')
compound agent "$agent" files upload ./data/
compound agent "$agent" say "Build a summary workbook from the uploaded data"
compound agent "$agent" status --json
compound agent "$agent" files download --all -o ./out
```

`compound agent <agent-id> ...` works on that agent and its drive. The agent runs the work in the background; `compound agent <agent-id> activity --follow` prints its progress, and `compound agent <agent-id> files` shows the documents it created.

## Update

```bash
compound update
```
