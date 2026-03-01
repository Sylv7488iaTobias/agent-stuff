---
name: kbrainstorm
description: "You MUST use this before any creative work - creating features, building components, adding functionality, or modifying behavior. Explores user intent, requirements and design before implementation."
---

# Brainstorming Ideas Into Designs

## Overview

Help turn ideas into fully formed designs and specs through natural collaborative dialogue.

Start by understanding the current project context, then ask questions one at a time to refine the idea. Once you understand what you're building, present the design in small sections (200-300 words), checking after each section whether it looks right so far.

## How to Ask Questions

You have the `ask_question` tool. Use it for **every** question during brainstorming. It shows an interactive TUI where the user can select an option, edit it inline, or type a freeform answer.

**One tool call per question.** Each answer may influence your next question, so do NOT batch multiple `ask_question` calls in a single turn. Ask one, process the answer, then ask the next.

### Multiple choice questions (preferred)

Provide `options` when you can anticipate likely answers. The user can select an option and edit it inline before submitting, or pick "Type something" to write from scratch.

```
ask_question({
  question: "What is the primary purpose of this feature?",
  context: "This helps me understand the scope and target audience",
  options: [
    { label: "User onboarding", description: "New user registration and setup flow" },
    { label: "Data export", description: "Export data in various formats" },
    { label: "Admin dashboard", description: "Internal monitoring and management" }
  ]
})
```

### Open-ended questions

Omit `options` for questions that need freeform answers. The user gets an editor directly.

```
ask_question({
  question: "What existing patterns in the codebase should we follow?",
  context: "I'll look at those files for reference"
})
```

## The Process

**Understanding the idea:**
- Check out the current project state first (files, docs, recent commits)
- Ask questions one at a time using the `ask_question` tool
- Prefer multiple choice questions when possible, but open-ended is fine too
- Only one question per turn - each answer may influence the next question
- Focus on understanding: purpose, constraints, success criteria

**Exploring approaches:**
- Propose 2-3 different approaches with trade-offs
- Present options conversationally with your recommendation and reasoning
- Lead with your recommended option and explain why

**Presenting the design:**
- Once you believe you understand what you're building, present the design
- Break it into sections of 200-300 words
- Ask after each section whether it looks right so far (use `ask_question`)
- Cover: architecture, components, data flow, error handling, testing
- Be ready to go back and clarify if something doesn't make sense

## After the Design

**Documentation:**
- Write the validated design to `docs/plans/YYYY-MM-DD-<topic>-design.md`
- Use elements-of-style:writing-clearly-and-concisely skill if available
- Commit the design document to git

**Implementation (if continuing):**
- Ask: "Ready to set up for implementation?" (using `ask_question`)
- Use superpowers:using-git-worktrees to create isolated workspace if available
- Use superpowers:writing-plans to create detailed implementation plan if available

## Key Principles

- **One question at a time** - Don't overwhelm with multiple questions; each answer informs the next
- **Always use `ask_question`** - Never ask questions in plain text; always use the tool
- **Multiple choice preferred** - Easier to answer than open-ended when possible
- **YAGNI ruthlessly** - Remove unnecessary features from all designs
- **Explore alternatives** - Always propose 2-3 approaches before settling
- **Incremental validation** - Present design in sections, validate each
- **Be flexible** - Go back and clarify when something doesn't make sense
