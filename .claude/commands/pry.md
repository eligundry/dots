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

2. **Over-engineering check.** Read `~/.agents/skills/ponytail-review/SKILL.md`
   and apply it to everything the PR will contain, i.e. the staged changes plus
   any earlier commits on this branch:
   ```bash
   git diff --staged --merge-base origin/HEAD
   ```
   (If `origin/HEAD` isn't set, use `origin/<default branch>` from
   `gh repo view --json defaultBranchRef`.)
   - If it comes back `Lean already. Ship.`, continue.
   - Otherwise show the user the findings and the `net:` line, then **stop and
     ask** whether to apply them, ignore them and open the PR, or stop. If they
     choose to apply, make the changes, stage them, and continue from step 3.

3. Run `git log --oneline -10` to understand the commit message style used in this repository.

4. Create a commit with a well-crafted message that:
   - Summarizes the nature of the changes (new feature, bug fix, refactor, etc.)
   - If a ticket number was provided in the arguments, prefix the message with `TICKET-NUMBER: `
   - If guidance text was provided, incorporate that context into the message
   - Follows the repository's commit message conventions
   - Adds the Claude `Co-authored-by` trailer

5. Push only the current branch to the remote. Use `git push -u origin HEAD` to push the current branch (setting upstream if needed).

6. Create a PR using `gh pr create` with:
   - A title matching the commit message (including ticket prefix if provided)
   - A body containing:
     - `## Summary` section with 1-3 bullet points
     - `## Test plan` section with testing checklist
     - Footer: `Generated with [Claude Code](https://claude.com/claude-code)`

7. Return the PR URL when complete.

8. **Review Notification**: After creating the PR, wait for review feedback using a background task. Use Bash with `run_in_background: true`:
   ```bash
   sleep 600 && gh api repos/OWNER/REPO/pulls/PR_NUMBER/reviews --jq '.[] | select(.user.login == "copilot" or .user.login == "github-actions[bot]") | select(.state != "APPROVED") | .id' | tail -1
   ```
   - After the background task completes, check its output.
   - If a review ID is returned, fetch the review content using the same script `/reviewy` uses:
     ```bash
     gh-review-threads OWNER REPO PR_NUMBER REVIEW_ID
     ```
   - **Do NOT automatically address review comments.** Instead, notify the user:
     - If Copilot submitted a review with comments, summarize the review content from `gh-review-threads` and provide the review URL so they can decide whether to run `/reviewy` to address them.
     - If Copilot approved, report that Copilot is satisfied.
