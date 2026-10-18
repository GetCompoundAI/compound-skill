# Compound CLI

Compound is an AI analyst for finance work. Message an agent in plain English: it researches your files and public company data, builds Excel models, PowerPoint decks, Word memos and PDFs, cites each figure to its source, and keeps working in the background while you check in.

## Use Cases

- **Financial models**: Build DCF, LBO, comparable companies, precedent transactions, public company, operating, add-on acquisition, debt schedule, returns, working capital, EBITDA bridge, SaaS cohort and real estate models as formatted Excel workbooks with live formulas
- **Company research**: Answer questions from a company's SEC filings, earnings call transcripts, financial statements, stock prices and news, with each number cited to the passage it came from
- **Data room and document review**: Upload a folder or a .zip of PDFs, workbooks, decks, documents and emails; the agent reads and cross-references them and writes up findings, summaries or diligence lists
- **Decks, memos and reports**: Turn the analysis into a PowerPoint deck, a Word memo or a PDF, or have the agent revise one you upload; every edit saves a new version
- **Screening**: Find companies by criteria such as country, industry or headcount, and compare them in a table
- **Monitoring**: Ask the agent to watch companies (earnings, filings, news) or to run a request on a schedule, such as a weekly portfolio update; each event or run becomes a task, and its output lands in the agent's files
- **Repeatable analysis**: Have the agent build a workbook template once, then run each new company or deal through a copy of it
- **Work you steer**: The agent splits work into tasks, asks you when it needs input, and proposes work for your approval; `compound agent status` shows what is waiting on you, and you answer from the terminal

## Data Integrations

Compound has built-in access to SEC filings, financial statements, stock prices, earnings call transcripts, company news, prediction markets and the web — no API keys needed.

## Authentication

Run `compound login` to authenticate via browser; in a terminal it reads the code you paste back. Without a terminal it prints the sign-in link and exits: give the user the link, then run `compound login --code <code>` with the code the page shows. `compound logout` signs out and ends that sign-in on the server.

## Commands

Run `compound --help` for the full command surface; see `SKILL.md` for usage and workflows.
