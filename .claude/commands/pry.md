# Commit and Open PR

Commit all staged changes and open a pull request using `gh`.

## Arguments

$ARGUMENTS

The argument above may be:
- A ticket number prefix (e.g., `JIRA-123`, `EDP-456`) that should be prepended to the commit message and PR title in the format `TICKET-123: Message`
- Free-form text that should influence or guide the commit message and PR title content
- Empty, in which case generate the message based solely on the changes

## Instructions

1. First, run `git status` and `git diff --staged` to understand what changes are being committed. If nothing is staged, stage all changes with `git add -A`.

2. Run `git log --oneline -10` to understand the commit message style used in this repository.

3. Create a commit with a well-crafted message that:
   - Summarizes the nature of the changes (new feature, bug fix, refactor, etc.)
   - If a ticket number was provided in the arguments, prefix the message with `TICKET-NUMBER: `
   - If guidance text was provided, incorporate that context into the message
   - Follows the repository's commit message conventions
   - Adds the Claude `Co-authored-by` trailer

4. Push only the current branch to the remote. Use `git push -u origin HEAD` to push the current branch (setting upstream if needed).

5. Create a PR using `gh pr create` with:
   - A title matching the commit message (including ticket prefix if provided)
   - A body containing:
     - `## Summary` section with 1-3 bullet points
     - `## Test plan` section with testing checklist
     - Footer: `Generated with [Claude Code](https://claude.com/claude-code)`

6. Return the PR URL when complete.
