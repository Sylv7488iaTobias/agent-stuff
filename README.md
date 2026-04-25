# Agent Stuff

Extensions, skills, and themes for [Pi](https://buildwithpi.ai/), the coding agent.

> **Note:** These are tuned for my workflow. They may need modification for yours.

## Installation

Install from git (extensions, skills, and themes are all discovered automatically):

```bash
pi install git:github.com/kostyay/agent-stuff
```

To try a single extension without installing the full package:

```bash
pi -e ./pi-extensions/status-bar.ts
```

## Extensions

All extensions live in [`pi-extensions/`](pi-extensions). Each file is a self-contained Pi extension — one responsibility per file, no cross-extension dependencies.

| Extension | Description |
|-----------|-------------|
| [`answer.ts`](pi-extensions/answer.ts) | Extracts questions from assistant responses and presents an interactive TUI for answering them one by one |
| [`bgrun.ts`](pi-extensions/bgrun.ts) | `/bgrun` and `/bgtasks` commands + `bgrun` tool — run and manage background tasks via tmux with auto-derived window names, interactive task manager TUI (kill all with `K`), and `bgrun:stats` event for status-bar integration. Commands run as direct pane processes with `remain-on-exit` for post-exit output capture |
| [`clear.ts`](pi-extensions/clear.ts) | `/clear` command — starts a new session (alias for `/new`) |
| [`cmux.ts`](pi-extensions/cmux.ts) | cmux sidebar integration — pushes agent state (model, thinking, tokens, cost, tool activity) to the cmux sidebar via status keys and notifications. No-op when not running inside cmux |
| [`commit.ts`](pi-extensions/commit.ts) | `/commit` command — stages all changes, generates a Conventional Commits message via LLM, creates a side branch if on the default branch |
| [`context.ts`](pi-extensions/context.ts) | `/context` command — shows loaded extensions, skills, AGENTS.md/CLAUDE.md, and token usage |
| [`control.ts`](pi-extensions/control.ts) | Session control via Unix domain sockets for inter-session communication |
| [`files.ts`](pi-extensions/files.ts) | `/files` command — file browser merging git status with session-referenced files, plus diff/edit actions |
| [`git-rebase-master.ts`](pi-extensions/git-rebase-master.ts) | `/git-rebase-master` command — fetches latest main/master and rebases current branch with automatic LLM conflict resolution |
| [`claude-import.ts`](pi-extensions/claude-import.ts) | Loads commands, skills, and agents from `.claude/` directories (project + global) and registers them as `/claude:*` commands |
| [`kbrainstorm.ts`](pi-extensions/kbrainstorm.ts) | `ask_question` tool — interactive TUI for brainstorming with multiple-choice and freeform answers |
| [`ticket/`](pi-extensions/ticket) | `ticket` tool — git-backed ticket tracker storing tickets as markdown files in `.tickets/` with hierarchy, dependencies, status workflow, auto-closing of completed epics, and auto-run continuation across epics with context compaction |
| [`loop.ts`](pi-extensions/loop.ts) | `/loop` command — runs a follow-up prompt in a loop until stopped |

> **Personal note:** I mostly use `bgrun`, `commit`, and `ticket` day-to-day. The `claude-import.ts` extension is handy if you're migrating from Claude Code and want to reuse existing slash commands.
