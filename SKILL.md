---
name: compound
description: "AI analyst for finance work — build Excel models, decks, memos and PDFs from your files, SEC filings, financials, earnings calls and prediction markets, with every figure cited, and watch companies or run work on a schedule"
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

# Compound CLI

Compound is an AI analyst for finance work. You send a request in plain English to an agent. The agent researches the user's files and public company data, builds Excel models, PowerPoint decks, Word memos and PDFs, and cites each figure to its source. **The user does not create tasks; the agent does.** You ask with `compound agent say`, the agent opens and runs the tasks it needs, and you follow up on those tasks (reply, change state, file in a project, share, download files) and give the user their links.

Every command for work is `compound agent <subcommand>`. With no agent named, it goes to **Frankie**, the user's default agent.

## How to work with Compound

1. **Start the work.** Send the user's request as they said it:
   ```bash
   compound agent say "Build a DCF for NVDA in Excel"
   ```
   `say` waits up to 60 seconds for the agent to open a task, then prints two lines:
   ```
   Frankie took it on as task #89: NVDA DCF
   Open: https://getcompound.ai/agent/default/tasks/89
   ```
   If the agent answers in the chat instead, `say` prints the answer and the chat link. If it prints `It has not opened a task yet`, run `compound agent tasks` a little later.
2. **Tell the user in 1–2 lines.** Relay the agent, the task number and title, and the `Open:` link. Do not restate the request. Example: *Frankie took it on as task #89: NVDA DCF — https://getcompound.ai/agent/default/tasks/89. I'll check back when it finishes.*
3. **Check progress when the user asks, or when you said you would.**
   ```bash
   compound agent status          # what needs the user, what is running or paused
   compound agent task 89         # one task: state, steps, files, comments
   ```
   A task is Running until it is **Done**. Models and decks take minutes, not seconds. Do not poll in a tight loop: check at most every few minutes.
4. **Answer what the agent asks.** `status` lists it under "Needs you":
   - A task in **Needs input** has a question. Read it with `compound agent messages --task 89`; the question prints its choices and the exact command that answers it: `compound agent task 89 reply --answers <message-id> "<answer>"`. The answer can be one of the choices or free text. Ask the user if you do not know the answer.
   - A **Proposed** task waits for approval: `compound agent task 92 set running` (run now), `set planned` (put it on its schedule) or `set dismissed` (turn it down).
   - A **proposal** (an id, not a task number): `compound agent proposal <id> accept` or `decline`.
5. **Follow up on a task** (more instructions, a correction, a new file): `compound agent task 89 reply "Use a 9% WACC" [--attach ./new.xlsx]`, or `compound agent say --task 89 "..."`. A task's effort is the agent's to set: to change it, ask in words on the task (`compound agent say --task 89 "work this at Deep effort"`). `--effort` with `--task` is refused.
6. **Deliver the results.** `compound agent task 89` lists the task's files, each with its version and link. Give the user the links. To get a local copy, take the file ids from `compound agent task 89 --json` (`files[].file_id`) and run `compound agent files download <file-id> -o ./NVDA_DCF.xlsx`. With **one** file id, `-o` is the file to write; with several ids (or `--all`), `-o` is a folder. Missing folders are created.

Options on `say` you will use:

| Option | Use it when |
| --- | --- |
| `--attach <paths...>` | The user gives you files or folders. They upload into `uploads/` and the agent reads them. A `.zip` (or other archive, `.msg`, `.eml`) is unpacked into the files on upload. |
| `--project <project-id>` | The work belongs to a project (a company, deal or recurring report). Takes the project **id**: find it with `compound agent projects`. |
| `--effort fast\|auto\|deep` | The user says "quick" (`fast`) or "be thorough" / "take your time" (`deep`). Default `auto`. Main chat only, as the app's effort toggle: the agent sets the task's effort from it. Not with `--task`. |
| `--task <n>` | The message is about an existing task. Not with `--project`. |
| `--wait <seconds>` | Default 60. `--wait 0` sends and looks once. |
| `--json` | You parse the result: `tasks[]` (each with `number`, `state`, `url`) and `reply`. |

## Decision rules

- **Route to Frankie.** Send new work with no agent named. Name another agent (`compound agent <agent-id> say ...`) only when the user names one, or when an agent clearly already holds this work (its project or files); check with `compound agent list`. `frankie` also names Frankie: `compound agent frankie tasks`.
- **A new company or deal is a project, not an agent.** Run `compound agent new` only when the user asks for a new agent.
- **Use the CLI's links.** Every command ends with an `Open: <url>` line, and `--json` objects carry `url`. Give the user these links. Never build a link by hand, and never link to a file listing when a task link exists.
- **Parse `--json`, not tables.** `--json` prints one JSON object per line (NDJSON) and keeps full text and raw ISO times. Tables cut long text on a terminal.
- **Never print or ask for tokens.** If a command prints `Not signed in`, run `compound login`. Without a terminal it prints a sign-in link and exits. Give the user the link. The page shows a short code. When the user gives you the code, run `compound login --code <code>`.
- **Errors** print to stderr as `Error: <reason>` (API errors: `Error (<status>): <reason>`) and exit 1. The reason says what to run instead; for example an unknown project id says `list them with: compound agent projects`. A retired command prints the command that replaces it.
- **The CLI offers what the app offers, in the app's words.** Task states: Needs input, Running, Paused, Proposed, Done, Archived. Roles: Editor, Viewer. A viewer cannot upload, move, comment or share; `compound agent <agent-id> request-access` asks the owner for edit access.
- **Email goes through an agent.** No command sends mail. Ask the agent with `say`. See the email recipe for who it can write to.
- **Contact Support only for Compound itself.** When the user asks to contact support, report a problem with Compound (a bug, a failed command, a wrong result in the app) or request a feature, run `compound support --subject "<brief description>" "<message>"`, with `--type bug-report` or `--type feature-request` when it fits (default: General Support). For a long message, pipe it on stdin and leave out the message argument. Send it only when the user asks. It goes to the Compound team, not to an agent. Work on the user's files or companies goes to an agent with `say`. The server takes 2 requests per hour per user.

## Recipes

Each recipe: what the user says → the commands → what you tell the user.

**1. "Build a DCF for NVDA in Excel."**
```bash
compound agent say "Build a DCF for NVDA in Excel"
```
Tell: the `took it on as task #N` line and its link.

**2. "Here's a folder of PDFs, summarize them into a memo."**
```bash
compound agent say "Summarize these PDFs into a Word memo" --attach ./pdfs/
```
Tell: the task line and link.

**3. "What's the status of my tasks?" / "Is the model done?"**
```bash
compound agent status              # Needs you, Running, Paused, Unread (task numbers)
compound agent tasks --links       # every task with its own link
compound agent task 89             # one task's state and files
```
Find a task by its title in `status`, `tasks` or `finished`. Tell: what needs the user first, then what is running, then what finished, each with its task link.

**4. "The agent asked me something" / "What does it need?"**
```bash
compound agent status
compound agent messages --task 89
compound agent task 89 reply --answers <message-id> "Use the base case"
```
If you do not know the task number, it is in the "Needs you" part of `status`. Tell: the question and its choices; after the user answers, the reply you sent and the task link.

**5. "Change the model to use a 9% WACC" (a task already running or done).**
```bash
compound agent task 89 reply "Use a 9% WACC and rerun the valuation"
```
Tell: that you sent it on task #89, with the link.

**6. "Send me the model" / "Download what it made."**
```bash
compound agent task 89 --json        # files[].file_id, files[].filename, files[].url
compound agent files download <file-id> -o ./out/NVDA_DCF.xlsx            # one file: -o is the file
compound agent files download <file-id> <file-id> -o ./deliverables       # several: -o is the folder
```
Tell: the local paths and the task link. If you do not know the task, find it by title with `compound agent finished` (most recent first) or `compound agent files search <name>`.

**7. "Share the output with sam@bank.com."**
```bash
compound agent files share <file-id> --user sam@bank.com    # one output file (file id from task 89 --json), the Latest version
compound agent task 89 share add sam@bank.com               # or the whole task, a Snapshot
```
People get a read-only link. Share only what the user asked for. Add `--include-cited-files` to a task share only when the user asks to share the sources too: it also shares every file the task cites, such as the user's confidential uploads. Tell: who now has access and the link the command printed. Add `--latest` to a task share for a link that keeps updating.

**8. "Put this in the Q3 Review project."**
```bash
compound agent projects                         # find the Id of "Q3 Review" (--all for quiet ones)
compound agent project new "Q3 Review"          # only if it does not exist and the user agrees; prints its id
compound agent say "Update the Q3 bridge" --project <project-id>
compound agent task 89 project <project-id>     # or move an existing task
```
Tell: the task line (it names the project) and its link.

**9. "Do it quick" / "Be thorough" / a quick question.**
```bash
compound agent say "What is AMD's P/E?" --effort fast
compound agent say "Full diligence on the data room" --attach ./vdr/ --effort deep
```
A quick question often gets an answer in the chat, not a task: `say` prints the answer. Relay it with the chat link.
For a task that already exists, ask in words: `compound agent say --task 89 "work this at Deep effort"`. The agent changes the task's effort.

**10. "Run this every weekday morning."**
```bash
compound agent schedule new "Morning brief" -m "Summarize overnight news for my watchlist" --every weekday --at 07:30 --tz America/New_York
```
Each run opens a task. Tell: the schedule, its cadence and the link. `compound agent schedules` lists them.

**11. "Follow AAPL earnings."**
```bash
compound agent watch AAPL --events earnings,filings --note "margins and buyback"
```
The agent hears of each event; `alerts` sets how often. Tell: that the agent watches AAPL and for what. `compound agent companies` lists watched companies; `unwatch AAPL` stops.

**12. "Email the memo to sam@bank.com."**
No command sends mail; an agent does, from its own inbox. Frankie writes only to the user. To email someone else, use an agent the user owns, with email on, and the recipient on its allowlist or among its members:
```bash
compound agent <agent-id> settings email=on
compound agent <agent-id> email allowlist add sam@bank.com       # owner only
compound agent <agent-id> say "Email sam@bank.com the Q3 memo with a short cover note"
```
If the work is on Frankie, do not send or share anything yet. Tell the user Frankie can email only them, and offer: share the task or file with the recipient (recipe 7), or have Frankie email it to the user to forward.

## Concepts

- **Agent**: an AI analyst with one conversation, a board of tasks, and its own files. **Frankie** is the user's default agent; it stays private and cannot be shared or deleted.
- **Task**: one piece of work the agent opens and runs, with a number. The user asks; the agent creates the tasks. States: Needs input, Running, Paused, Proposed, Done, Archived. **Finished** means Done or Archived.
- **Project**: a named piece of work on one agent (a company, a deal, a report) with its own tasks and folder.
- **Proposal**: a change the agent asks the user to approve.
- **Files**: the agent's files. Each edit saves a new version. A downloaded docx or pptx links each citation to Compound; an xlsx has a note on each cited cell.
- **Effort**: Fast, Auto (default) or Deep, as the app's effort toggle in the main chat. A task's effort is the agent's to set: it takes it from the request, and changes it when the user asks in words on the task.

Data the agent has without setup: SEC filings, standardized and as-reported financials, stock prices, earnings call transcripts, company documents and news, company screens, Polymarket odds, and web search. Turn a source off per agent with `settings`.

## Command reference

`compound agent [<agent-id>|frankie] <subcommand>`. With no agent named: `COMPOUND_AGENT_ID`, else `config set default-agent`, else Frankie. Most commands take `--json`; list commands take `--links` (each row's link as a column). Run `compound agent <subcommand> --help` for every option.

### Conversation and tasks

```bash
compound agent say "<request>" [--attach <paths...>] [--project <id>] [--effort fast|auto|deep | --task <n>] [--wait 60] [--json]
compound agent status                                   # Needs you, Running, Paused, Unread, last message
compound agent messages [-n 20] [--task <n>] [--before <message-id>]   # questions print their choices and the answer command
compound agent activity [--task <n>] [-n 50] [-f]       # what the agent read, searched and wrote; -f follows live
compound agent tasks [-s needs-input running paused proposed done archived] [--project <id>] [--needs-review] [--mine|--others] [-n 50]
compound agent finished [--project <id>] [-s done|archived] [-n 50]
compound agent task <n>                                 # state, steps, files (version and link), comments
compound agent task <n> reply "<text>" [--answers <message-id>] [--step <n>] [--attach <paths...>]
compound agent task <n> set running|planned|paused|archived|done|dismissed
compound agent task <n> project <project-id|none>       # Move to project (not on a Proposed task)
compound agent task <n> read|unread                     # only on Done tasks
compound agent proposals
compound agent proposal <proposal-id> accept|decline [--to <agent-id>]
```

`task <n> set` moves: Proposed → `running` (accept, run now), `planned` (Plan it: accept onto its schedule) or `dismissed` (turn down; deleted). Running or Needs input → `paused`. Paused → `running`. Any → `archived`. Archived → `done`. Other moves fail and name the allowed ones.

### Projects

```bash
compound agent projects [--all]                          # Active, then Quiet; Id, Project, Tasks, Files
compound agent project <project-id>                      # its Tasks, Files and Activity
compound agent project new "<name>" [-d "<description>"] # name ≤120 chars
compound agent project <project-id> rename "<name>" [-d "<description>"]
compound agent project <project-id> delete [--force]     # archives its tasks, keeps its files
```

### Files

```bash
compound agent files [--path <folder>] [-r]              # one folder: folders, then files with File ID
compound agent files search <query> [--everywhere]       # by name; --everywhere: all agents
compound agent files upload <paths...> [--to <folder> | --project <id>]
compound agent files download <file-id> [--file-version <n>] [--no-citation-links] [-o <file>]
compound agent files download <file-id...> | --all [--no-citation-links] [-o <folder>]
compound agent files versions <file-id>
compound agent files export <file-id> --to pdf|xlsx [-o <file>]
compound agent files open-desktop <file-id>              # link that opens desktop Excel or PowerPoint
compound agent files mv <file-id> <new/path>
compound agent files rename-folder <folder> <new/folder>
compound agent files copy <file-id...> [--folder <path...>] --to <agent-id|frankie>
compound agent files rm <file-id...>                     # to the Recycle Bin; files trash, files restore
compound agent files share <file-id> --user <email...> | --public --file-version <n>
compound agent files shares <file-id>
compound agent files unshare <file-id> [--file-version <n>] [--user <email...>] [--public]
compound agent files signing <file-id> [--cancel <request-id>]
compound agent files sign <file-id> [--field kind:page:x0,y0,x1,y1 ...] [--request <id>] [--without-request]
compound agent comments <file-id> [--all]                # Excel, Word and PowerPoint files
compound agent comment <file-id> "<text>"                # the agent picks up an open comment
compound agent comment <comment-id> --reply "<text>" | --resolve | --delete
```

### Sharing

```bash
compound agent task <n> share [add <email...> [--latest] [--include-cited-files] | --public]
compound agent task <n> share remove <email|public...>
compound agent task <n> unshare
compound agent <agent-id> share [--user <email> | --team | --public] [--role editor|viewer]   # not Frankie; owner only
compound agent <agent-id> unshare --user <email> | --team | --public
compound agent <agent-id> members
compound agent <agent-id> request-access                 # on an agent you can only view
compound agent shared [--by-me]                          # what is shared with you
```

A task share is a Snapshot unless `--latest`; a public link is always a Snapshot.

### Schedules and companies

```bash
compound agent schedules
compound agent schedule new "<name>" -m "<instruction>" --every day|weekday|sun..sat|<1-31> --at HH:MM [--tz Area/City]
compound agent schedule <n> edit [--name <name>] [-m <instruction>] [--every <cadence> --at HH:MM] [--tz <zone>]
compound agent schedule <n> pause|resume|delete
compound agent companies "<name or ticker>"              # search; with no query: watched companies
compound agent company <company> [overview|financials|news|events|estimates]
compound agent company AAPL financials [--statement income|balance|cash] [--period annual|quarterly|ltm] [--periods 4]
compound agent watch <company> [--events earnings,filings,other,news,prediction_market,government_record] [--forms 10-K,8-K] [--note "<text>"]
compound agent unwatch <company>
compound agent alerts [--deliver immediate|hourly|daily|weekly] [--on|--off]
```

### Inbox, notifications and account

```bash
compound agent inbox [<email-id>]                        # read-only; to send, ask the agent with say
compound agent email allowlist [add|remove <address-or-domain...>] [--direction both|outbound|inbound]
compound agent notifications [<id> dismiss|grant | dismiss-all]
compound agent connections [connect|disconnect <name>]   # the user's connected apps; connect prints a sign-in link
compound agent settings [web=off email=on connectors=on time_zone=America/New_York name="..."]
compound agent <agent-id> properties [Name=Value ...]    # team custom fields
compound agent usage [billing]                           # credits used and left
compound agent citation <key>                            # a citation's source, as JSON
compound agent list                                      # agents, Frankie first
compound agent new "<name>"                              # only when the user asks for a new agent
compound agent <agent-id> delete [--force] | restore | purge [--force];  compound agent trash
```

### Setup

```bash
compound login                       # terminal: opens the sign-in page, reads the code
compound login --code <code>         # no terminal: the code the sign-in page shows
compound logout                      # end the saved sign-in on the server and remove it
compound whoami                      # signed-in email and user id
compound support --subject "<subject>" ["<message>"] [--type general|bug-report|feature-request]   # Contact Support; message from stdin when left out
compound update                      # install the latest release (commands also self-update)
compound config set default-agent <agent-id> | auto-update on|ask|off
compound config show
```

| Variable | Use |
| --- | --- |
| `COMPOUND_AGENT_ID` | The agent when none is named |
| `COMPOUND_API_URL` / `COMPOUND_APP_URL` | API and app hosts (default: prod) |
| `COMPOUND_AUTO_UPDATE` | `on`, `ask` or `off` |
