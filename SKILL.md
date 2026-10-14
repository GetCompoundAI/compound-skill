---
name: compound
description: "AI analyst for finance work — build Excel models, decks, memos and PDFs from your files, SEC filings, financials, earnings calls and prediction markets, with every figure cited, and follow companies or run work on a schedule"
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

Compound is an AI analyst for finance work. Message an agent in plain English: it researches your files and public company data, builds Excel models, PowerPoint decks, Word memos and PDFs, cites each figure to its source, and keeps working in the background while you check in.

## Use Cases

- **Financial models**: Build DCF, LBO, comparable companies, precedent transactions, public company, operating, add-on acquisition, debt schedule, returns, working capital, EBITDA bridge, SaaS cohort and real estate models as formatted Excel workbooks with live formulas
- **Company research**: Answer questions from a company's SEC filings, earnings call transcripts, financial statements, stock prices and news, with each number cited to the passage it came from
- **Data room and document review**: Upload a folder or a .zip of PDFs, workbooks, decks, documents and emails; the agent reads and cross-references them and writes up findings, summaries or diligence lists
- **Decks, memos and reports**: Turn the analysis into a PowerPoint deck, a Word memo or a PDF, or have the agent revise one you upload; every edit saves a new version
- **Screening**: Find companies by criteria such as country, industry or headcount, and compare them in a table
- **Monitoring**: Ask the agent to follow companies (earnings, filings, news) or to run a request on a schedule, such as a weekly portfolio update; each event or run becomes a task, and its output lands in the agent's files
- **Repeatable analysis**: Have the agent build a workbook template once, then run each new company or deal through a copy of it
- **Work you steer**: The agent splits work into tasks, asks you when it needs input, and proposes work for your approval; `compound agent status` shows what is waiting on you, and you answer from the terminal

## Data Integrations

Compound has built-in access to:

- **SEC filings** — every form a company has filed: 10-K, 10-Q, 8-K, proxy statements, 13F holdings, insider forms and the rest, with exhibits
- **Financials** — income statement, balance sheet and cash flow by period, standardized across companies or as reported, plus daily stock prices and share counts
- **Earnings calls** — transcripts with management's prepared remarks and the analyst Q&A
- **Company documents and news** — investor presentations, press releases, reports, news and fundraising history
- **Company screens** — companies that match criteria such as country, exchange, industry or headcount
- **Prediction markets** — Polymarket odds and how they moved
- **Web search**

No API keys needed — message the agent about a company or topic and it fetches the data. Turn a source off for one agent with `compound agent settings`.

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
# --attach uploads files or folders into uploads/ and hands them to the agent;
# --effort is fast, auto (default) or deep; --task says it on one task.
compound agent say "check the revenue model for broken links"
compound agent say "review this data room" --attach ./vdr/ --effort deep
compound agent say "use the Q3 numbers" --task 12

# The conversation so far, each message with its id. A question the agent asked
# prints its choices and the command that answers it. Under a message that cites
# sources, each source prints as `[N] <name> — <Compound link>`, or `[N] <key>`
# when it cannot be resolved.
compound agent messages [-n 20] [--task <n>] [--before <message-id>] [--json]

# What it has been doing. --follow keeps the stream open and prints ops live;
# --raw prints every stream frame, not only activity.
compound agent activity [-n 50] [--json]
compound agent activity --follow [--raw] [--json]

# The work it is holding. States: proposed, running, needs_input, paused, completed, archived
compound agent tasks [-s needs_input running] [-n 50] [--json]

# One task: show it, open a new one, move it, reply on it, file it in a project, or share it
compound agent task <number> [--json]
compound agent task new "Q3 variance memo" [-m "<body markdown>"] [--project <project-id>] [--effort fast|auto|deep] [--json]
compound agent task <number> set <state> [--json]
compound agent task <number> reply "use the Q3 file" [--answers <message-id>] [--step <n>] [--attach <paths...>]
compound agent task <number> project <project-id|none>
compound agent task <number> share --public | --user <email...> [--latest]   # a snapshot link; --latest keeps updating (not with --public)
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
`--answers` names the question the agent asked (the message id `agent messages`
prints) and `--step` names the workflow step.

```bash
# Proposals: changes the agent asks you to approve
compound agent proposals [--json]
compound agent proposal <proposal-id> accept|decline [--to <agent-id>] [--json]   # --to: where a copy-to-agent proposal copies

# Projects group related tasks and files; each has its own folder
compound agent projects [--json]
compound agent project new "Acme diligence" [-d "<description>"]
compound agent project <project-id> rename "<name>" | delete   # delete archives its tasks and keeps its files

# Schedules: each run opens a task. --every is day, weekday, sun..sat or a day
# of the month (1-31); --cron takes any five-field expression instead.
compound agent schedules [--json]
compound agent schedule new "Weekly update" -m "<instruction>" --every mon --at 09:00 [--tz America/New_York]
compound agent schedule <number> edit [--name <name>] [-m <instruction>] [--every <cadence> --at HH:MM | --cron <expr>] [--tz <zone>]
compound agent schedule <number> pause | resume | delete

# Companies: search, and follow one so the agent watches its earnings, filings and news
compound agent companies "<name or ticker>" [--json]
compound agent companies                          # the companies it follows
compound agent follow <entity-id> [--note "<what you care about>"]
compound agent unfollow <entity-id>

# Comments on a file: the agent picks up an open thread
compound agent comments <file-id> [--all] [--json]
compound agent comment <file-id> "<text>"
compound agent comment <thread-id> --reply "<text>"
compound agent comment <thread-id> --resolve

# The agent's email address and threads, and what needs you on this agent
compound agent inbox [<thread-id>] [--page <token>] [--json]
compound agent notifications [clear] [--json]

# Your credits this period and the last 30 days' credits by agent
compound agent usage [--json]

# Settings: <capability>=on|off (org_conventions, email, connectors, proposals,
# questions, web, company_data, prediction_markets), and name, description and
# time_zone as <setting>=<text>
compound agent settings [--json]
compound agent settings web=off email=on time_zone=America/New_York name="Acme deal"

# A citation's saved source and its resolved target, as JSON, by the key in a
# cited file, a message or a ?cite=<key> link
compound agent citation <key>
```

### Files

Upload files or folders so the agent can read them; a folder upload keeps the
folder's name and the paths inside it. A downloaded docx or pptx has each citation linked to Compound;
a downloaded xlsx has a note on each cited cell naming its sources, with a
Compound link to each. A file the server cannot link downloads as stored.

```bash
compound agent files [--json]                         # list
compound agent files upload ./report.xlsx ./data-folder/ [--to <folder>] [--json]
compound agent files download <file-id> [--file-version <n>] [-o out.xlsx]  # one id: -o is the file to write
compound agent files download <file-id> <file-id> [-o out-dir]
compound agent files download --all [-o out-dir]       # several ids or --all: -o is a folder; each file keeps its folder
compound agent files mv <file-id> <new/path.xlsx>      # rename or move
compound agent files rm <file-id...>                   # to the agent's trash
compound agent files trash [--json]
compound agent files restore <file-id...>
compound agent files share <file-id> --user <email...> | --public --file-version <n>   # live, or a pinned version (public needs one)
```

### Sharing

Only the agent's owner can list or change its sharing.

```bash
compound agent share [--json]                          # who has access
compound agent share --public                          # turn on the read-only public link
compound agent share --team [--role read|write]        # your team; default role read
compound agent share --user alice@example.com [--role read|write]   # default role read; on someone already shared with, changes their role
compound agent unshare --public | --team | --user alice@example.com
```

### Moved commands

The top-level `compound drives` and `compound files` commands, and the
`agent run|plan|dismiss|pause|resume|archive|unarchive|accept|decline|watch`
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
