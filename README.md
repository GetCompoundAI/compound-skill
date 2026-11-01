# Compound CLI and agent skill: Excel, PowerPoint and Word work for AI agents

[Compound](https://getcompound.ai) is an AI analyst for finance work. From Claude Code, Codex, OpenClaw or your own agent, send a task through the `compound` CLI: Compound researches your files and public company data, builds the Excel model, PowerPoint deck, Word memo or PDF, cites each figure to its source, and returns the file to your agent.

Documentation: https://getcompound.ai/help/compound-cli

## Install

1. **Install the CLI and the skill.**
   - **Claude Code**: type these two commands in Claude Code, then restart it. Plugins install only through commands the user types, so an agent asks the user to run them. The plugin installs the `compound` binary when a session starts.
     ```
     /plugin marketplace add getcompoundai/compound-skill
     /plugin install compound@getcompoundai-compound-skill
     ```
   - **Codex**: install the CLI, then save `SKILL.md` as a user skill:
     ```bash
     curl -fsSL https://raw.githubusercontent.com/getcompoundai/compound-skill/main/install.sh | bash
     mkdir -p ~/.agents/skills/compound
     curl -fsSL https://raw.githubusercontent.com/getcompoundai/compound-skill/main/SKILL.md -o ~/.agents/skills/compound/SKILL.md
     ```
     Restart Codex so it loads the skill. `compound` calls the Compound API over the network, so approve running `compound` outside the sandbox when Codex asks.
   - **OpenClaw**: install the skill with OpenClaw's skill installer:
     ```bash
     openclaw skills install git:getcompoundai/compound-skill
     ```
   - **Any other agent, or a terminal**: install the CLI:
     ```bash
     curl -fsSL https://raw.githubusercontent.com/getcompoundai/compound-skill/main/install.sh | bash
     ```
     The script prints the path it installed to: `/usr/local/bin/compound` when that folder is writable, else `~/.local/bin/compound`. If the shell then says `compound: command not found`, run it by that full path. To install a specific release, add `-s` and its tag after `bash`, for example `bash -s v0.5.13183`.
2. **Sign in** with `compound login`.
   - In a terminal, it opens the sign-in page in a browser; paste the code it shows back into the terminal.
   - Run by an agent without a terminal, it prints a sign-in link and exits. The agent gives the user the link, the user signs in and gives back the code, and the agent runs `compound login --code <code>`.

   `compound logout` signs out and ends that sign-in on the server.
3. **Verify.** `compound whoami` prints the signed-in email and user id.
4. **Keep the instructions.** Outside Claude Code, Codex and OpenClaw, save [`SKILL.md`](SKILL.md) as a skill or as standing instructions for the agent. It says how to send work, follow tasks and deliver files.

## Quick start

```bash
compound login                                    # sign in
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
| `compound agent status` | What needs you (questions, proposals), what is running |
| `compound agent tasks` | Show the tasks the agent is holding |
| `compound agent task <n> set <state>` | Run, pause or archive a task |
| `compound agent files` | List the agent's files |
| `compound agent files upload <paths...>` | Upload files or folders to the agent |
| `compound agent list` | List your agents |

See `compound --help` for all commands.

## Use standalone (scripts, CI, your own agents)

The `compound` binary is self-contained, so anything that can run a command can use it. Install it with the script above, or download the archive for your platform (`linux-x64`, `linux-arm64`, `darwin-x64`, `darwin-arm64`) from the [releases page](https://github.com/getcompoundai/compound-skill/releases/latest).

`compound login` stores credentials in `~/.compound/config.json` and refreshes them automatically, so one sign-in keeps scripts and agents signed in across sessions.

```bash
export COMPOUND_AGENT_ID=<id>    # optional: the agent commands use when none is named
```

For machine-readable output, list, upload and agent commands take `--json` and print NDJSON, one object per line:

```bash
compound agent list --json
compound agent messages --json
compound agent activity --follow --json
```

A scripted pipeline that uploads data, starts the work and collects the produced documents:

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

## Use with OpenClaw

```bash
openclaw skills install git:getcompoundai/compound-skill
```
