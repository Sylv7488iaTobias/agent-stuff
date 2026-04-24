# Agent Notes

## Overview

This repo contains pi coding agent extensions, skills, and themes.

- **Extensions** live in `./pi-extensions/` (single `.ts` files, one per extension).
- **Skills** live in `./skills/`.
- **Themes** live in `./pi-themes/`.

### Canonical Extension Documentation

Always fetch the latest pi extension docs before creating or modifying extensions:

- **Extensions API**: https://github.com/badlogic/pi-mono/tree/main/packages/coding-agent/docs/extensions.md
- **TUI Components**: https://github.com/badlogic/pi-mono/tree/main/packages/coding-agent/docs/tui.md
- **Session Management**: https://github.com/badlogic/pi-mono/tree/main/packages/coding-agent/docs/session.md
- **Examples**: https://github.com/badlogic/pi-mono/tree/main/packages/coding-agent/examples/extensions/

Use the `summarize` skill to fetch and convert these docs when you need API details. Do **not** rely on memorized patterns — the API evolves.

---

## Code Quality

Apply the `@skills/js-code-simplifier/` skill to **every** code change in this repo. This means:

1. Read every file in scope before editing.
2. Follow the refinement principles: clarity over brevity, explicit types, early returns, sorted imports, no dead code.
3. After changes, list what was simplified and why.

### Additional Rules

- **JSDoc on every export.** All exported functions, types, and constants must have a JSDoc comment explaining purpose and usage.
- **Explicit TypeScript types.** No implicit `any`. Use precise types for function parameters, return values, and tool parameter schemas.
- **`function` declarations** for top-level exports. Arrow functions for callbacks and inline handlers only.
- **Imports sorted** alphabetically by source, grouped: pi packages first, then node built-ins, then relative.

> **Personal note:** I'm also enforcing a max line length of 100 characters for readability in my editor setup.

---

## Extension Design Rules

### One Responsibility Per Extension

Each `.ts` file in `pi-extensions/` must own exactly **one** concern:

- A command (e.g., `clear.ts` registers `/clear`)
- A tool (e.g., a standalone `ask_question` tool)
- An event handler (e.g., `notify.ts` handles `agent_end`)
- A UI component (e.g., `status-bar.ts` manages footer status)

If an extension grows beyond ~400 lines, split it. If it does two unrelated things, split it.

### Strict Isolation — No Cross-Extension Imports

Extensions must **not** import from or depend on other extensions in this repo. Each extension is self-contained at the module level.

**Wrong:**
```typescript
// plan-ask.ts
import { askQuestion } from "./kbrainstorm"; // ❌ Cross-extension import
```

**Right:**
Each extension registers its own tools/commands. If two extensions need the same capability, extract it into a shared utility in a `lib/` directory, or better yet, make each extension independently register what it needs.

### Cross-Extension Communication via `pi.events`

Extensions communicate at runtime through the shared event bus (`pi.events`), never through imports. Data-producing extensions emit typed events; consuming ex