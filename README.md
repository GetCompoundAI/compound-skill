# Compound

Compound is an AI analyst for finance work. Message an agent in plain English: it researches your files and public company data, builds Excel models, PowerPoint decks, Word memos and PDFs, cites each figure to its source, and keeps working in the background while you check in.

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

`login` opens a browser sign-in page and prompts you to paste a code back. Without a terminal it prints the link; run `compound login --code <code>` with the code the page shows. `compound logout` signs out.

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
export COMPOUND_AGENT_ID=<id>    # optional: the agent commands use when none is named
```

For machine-readable output, list, upload and agent commands take `--json` and print NDJSON, one object per line:

```bash
compound agent list --json
compound agent messages --json
compound agent activity --follow --json
```

A scripted pipeline — upload data, analyze, collect the produced documents:

```bash
project=$(compound agent project new "Nightly Report" --json | jq -r '.id')
task=$(compound agent say "Build a summary workbook from this data" --attach ./data/ --project "$project" --json | jq -r '.tasks[0].number')
compound agent task "$task" --json | jq -r '.state'      # until "completed"
mkdir -p out && (cd out && compound agent task "$task" --json | jq -r '.files[].file_id' | xargs compound agent files download)   # each file keeps its folder
```

Work goes to Frankie, your default agent, unless you name one: `compound agent <agent-id> ...` works on that agent and its files. `compound agent task <n>` shows a task's state and the files it made, each with its link; `compound agent activity --follow` prints the agent's progress live.

## Update

```bash
compound update
```

The CLI also checks for a new release before each command. In a terminal it asks first; elsewhere it updates itself. Turn this off with `compound config set auto-update off`.
