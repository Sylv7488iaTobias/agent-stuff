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

> **Personal note:** I prefer `const` over `let` wherever possible — if a variable is never reassigned, it should be `const`. Flag any `let` that could be `const` during review.

> **Personal note:** Prefer `interface` over `type` aliases for object shapes — easier to extend later and clearer intent.

> **Personal note:** Prefer `===` over `==` for all equality checks — no implicit coercion. Flag any loose equality during review.

> **Personal note:** Prefer named exports over default exports — makes refactoring and searching easier, and avoids inconsistent import naming across files.

> **Personal note:** Prefer `readonly` on interface properties that should not be mutated after construction — helps catch accidental reassignment at compile time.

> **Personal note:** Prefer `async`/`await` over raw `.then()`/`.catch()` chains — easier to read, easier to debug with stack traces, and consistent with the rest of the codebase style.

> **Personal note:** Prefer `unknown` over `any` when the type is genuinely uncertain — forces explicit narrowing before use and catches more errors.

> **Personal note:** Prefer explicit `return` types on all exported functions — even when TypeScript can infer them. Makes the intended contract obvious and surfaces unintended type widening early.
