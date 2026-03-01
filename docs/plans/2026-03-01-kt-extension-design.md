# kt Extension — Git-Backed Ticket Tracker for Pi

**Date**: 2026-03-01
**Status**: Approved
**Replaces**: `pi-extensions/todos.ts`

## Overview

A pi extension that provides a full-featured, git-backed ticket tracker inspired by [kticket](https://github.com/kostyay/kticket), with the TUI and session management of `todos.ts` and the agent-discipline UI of `tilldone.ts`. Single-file extension at `pi-extensions/kt.ts`.

## Storage

- **Directory**: `.tickets/` at the project root (git-tracked)
- **Format**: JSON frontmatter + structured markdown body
- **IDs**: project-prefix + 4 hex chars (e.g. `as-a1b2` for `agent-stuff`)
- **Locks**: `<id>.lock` files for multi-session safety (30-min TTL)
- **Settings**: `.tickets/settings.json` — `{ gc: true, gcDays: 7 }`

### File Format

```
{
  "id": "as-a1b2",
  "title": "Add user authentication",
  "status": "open",
  "type": "task",
  "priority": 2,
  "parent": "as-f3e4",
  "deps": ["as-c5d6"],
  "links": ["as-7890"],
  "assignee": "session-abc123",
  "external_ref": "gh-42",
  "tests_passed": false,
  "created_at": "2026-03-01T22:00:00.000Z"
}

Description text goes here.

## Design

Design notes.

## Acceptance Criteria

- Criterion 1

## Tests

- TestLoginSuccess
- TestLoginInvalidPassword

## Notes

**2026-03-01T23:00:00Z**
Progress note.
```

### ID Generation

Derive a 2–3 letter prefix from the project directory name by taking the first letter of each word (split on `-` or `_`). Append 4 random hex chars. Examples:
- `agent-stuff` → `as-xxxx`
- `my-app` → `ma-xxxx`
- `foo` → `fo-xxxx`

Partial matching: `a1b2` resolves to `as-a1b2c3d4` if unambiguous.

## Tool: `kt`

### Actions

| Action | Required Params | Optional Params | Description |
|--------|----------------|-----------------|-------------|
| `create` | `title` | `description`, `type`, `priority`, `parent`, `deps`, `external_ref`, `design`, `acceptance`, `tests` | Create a ticket |
| `show` | `id` | — | Show full ticket |
| `update` | `id` | any field | Update ticket fields |
| `delete` | `id` | — | Delete ticket (with lock) |
| `start` | `id` | — | Set `in_progress`, auto-claim to session |
| `close` | `id` | `tests_confirmed` | Set `closed` (validates tests if present) |
| `reopen` | `id` | — | Set back to `open` |
| `list` | — | `status`, `parent` | List tickets (default: open + in_progress) |
| `add-note` | `id`, `text` | — | Append timestamped note |

### Test Validation on Close

When `close` is called on a ticket with a `## Tests` section:

1. If `tests_confirmed` is not set or `false`, return an error containing the full test criteria:
   ```
   Cannot close as-a1b2: this ticket has test requirements that must pass first.

   ## Tests
   - TestLoginSuccess
   - TestLoginInvalidPassword

   Verify these tests pass, then call `kt close` again with tests_confirmed=true.
   ```
2. On retry with `tests_confirmed=true`, mark `tests_passed=true` and close.

This ensures the agent reads and validates the test criteria before closing.

## Slash Commands

### `/kt`

TUI browser (from todos.ts pattern):
- Fuzzy search across all tickets
- Select → action menu: view, work, refine, close, reopen, delete, copy path, copy text
- Quick keys: `Ctrl+Shift+W` work, `Ctrl+Shift+R` refine
- Work/refine inject prompts into the editor and exit the TUI

### `/kt-create`

Injects a prompt telling the agent to:
1. Ask the user to describe the feature/project
2. Create an epic ticket
3. Break it down into atomic task tickets (with parent set to the epic)

### `/kt-run-all`

Automated ticket processing loop:
1. Find next open ticket (with no unresolved deps, sorted by priority)
2. Ask user: "Work on `as-a1b2 'Add auth'` in a new session?" (Yes/No)
3. If yes: fork a new session, inject prompt "Work on ticket as-a1b2: [title]. [description]"
4. Agent works on ticket and closes it
5. On close: inject context into next iteration — "Ticket as-a1b2 'Add auth' completed. Notes: [notes from ticket]"
6. Loop to step 1

## UI Surfaces

### Widget (below editor)

Shows currently in-progress ticket(s):
```
● WORKING ON as-a1b2  Add user authentication
```

Uses `ctx.ui.setWidget()` — does not conflict with status-bar.ts footer.

### Status Line

Compact summary via `ctx.ui.setStatus()`:
```
🎫 kt: 5 tickets (2 remaining)
```

### Auto-Nudge

On `agent_end` event: if in-progress tickets remain, send a message nudging the agent:
```
⚠️ You still have 2 in-progress ticket(s):
  ● as-a1b2 [in_progress]: Add user authentication
  ○ as-c5d6 [open]: Write migration script

Continue working on them or close them when done.
```

### Render Functions

- `renderCall`: themed display of tool invocation
- `renderResult`: themed display of results with status icons, expandable details

## Session Integration

- `start` auto-claims ticket to current session (via `assignee` field)
- `close` releases assignment
- `/kt-run-all` manages session forking per ticket
- Completion context injected between tickets during run-all

## Data Model

```typescript
interface TicketFrontMatter {
  id: string;
  title: string;
  status: "open" | "in_progress" | "closed";
  type: "bug" | "feature" | "task" | "epic" | "chore";
  priority: number;        // 0-4, 0=highest
  parent?: string;         // parent ticket ID
  deps?: string[];         // dependency ticket IDs
  links?: string[];        // linked ticket IDs
  assignee?: string;       // session ID
  external_ref?: string;   // e.g. "gh-42"
  tests_passed: boolean;
  created_at: string;
}

interface TicketRecord extends TicketFrontMatter {
  description: string;
  design: string;
  acceptance: string;
  tests: string;
  notes: string;
}
```

## GC (Garbage Collection)

Same as todos.ts: on `session_start`, delete closed tickets older than `gcDays` (default 7). Configurable via `.tickets/settings.json`.
