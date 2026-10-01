---
name: eli-review
description: Review a GitHub PR the way Eli does - line comments for findings, overall commentary in the review body, request changes only for serious issues, approve when only nits remain, with a ponytail over-engineering pass and a bot disclaimer.
---

This skill is a pointer. The authoritative instructions live in a single
shared file used by both Claude Code and Codex:

    ~/.claude/commands/eli-review.md

Read that file **first**, then follow it exactly. Treat any arguments the
user passed to this skill as the `$ARGUMENTS` placeholder in that file.

Notes for running it under Codex:

- Where the file refers to Claude Code sub-agents or the scratchpad, do the
  work inline and use `${TMPDIR:-/tmp}` for the review JSON.
