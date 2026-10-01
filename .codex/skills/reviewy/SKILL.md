---
name: reviewy
description: Fetch comments from a specific GitHub PR review and address the requested changes, respecting the PR author's replies in each thread.
---

This skill is a pointer. The authoritative instructions live in a single
shared file used by both Claude Code and Codex:

    ~/.claude/commands/reviewy.md

Read that file **first**, then follow it exactly. Treat any arguments the
user passed to this skill as the `$ARGUMENTS` placeholder in that file.

Notes for running it under Codex:

- Where the file refers to Claude Code sub-agents or the Task tool, do the
  work inline instead.
- Where it says to add a `Co-Authored-By:` trailer "for the model you are
  currently running as", use the Codex model you are running as.
