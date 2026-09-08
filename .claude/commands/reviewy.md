# Address PR Review Comments

Fetch comments from a specific GitHub PR review and address the requested changes.

## Arguments

$ARGUMENTS

The argument should be a GitHub PR review URL in the format:
`https://github.com/OWNER/REPO/pull/PR_NUMBER#pullrequestreview-REVIEW_ID`

Example: `https://github.com/org/repo/pull/6737#pullrequestreview-3741755454`

## REQUIRED FIRST ACTION — do this before anything else

Parse OWNER, REPO, PR_NUMBER, and REVIEW_ID out of the URL, then make this Bash
call your **first tool call of the entire task**:

```bash
gh-review-threads OWNER REPO PR_NUMBER REVIEW_ID
```

`gh-review-threads` is an installed executable at `~/.local/bin/gh-review-threads`.
It is already on PATH. It wraps the GitHub GraphQL API and returns a compact,
threaded text format containing, for every thread in the target review: the file
path, line numbers, resolved status, `threadId`, per-comment `commentId`, comment
author, and **every reply in the thread, in order**.

### Do NOT substitute anything for this command

Reaching for the REST API with `jq` is the single most common way this task gets
botched. It is **forbidden** here. Specifically, do not use:

- `gh api repos/.../pulls/PR/comments` (with or without `--jq`)
- `gh api repos/.../pulls/PR/reviews/REVIEW_ID/comments`
- `gh pr view --json comments` / `gh pr view --comments`
- any hand-rolled `gh api graphql` query
- any other flattened-comment fetch

**Why this matters:** those endpoints return a flat list of comment objects. The
reply structure — who answered whom, and in what order — is destroyed. This task
depends entirely on reading full threads, because the PR author's replies
override the reviewer's original suggestion (see below). A flat comment dump
makes you implement changes the author already rejected, and it omits the
`threadId` values you need in step 8 to resolve threads. Flat output is not a
lossy-but-workable version of the right input; it is the wrong input.

If `gh-review-threads` errors or is genuinely missing, **stop and tell the user**
rather than falling back to `gh api`. Do not work around it.

## Instructions

1. Parse the URL to extract:
   - Owner and repo (e.g., `org/repo`)
   - PR number (e.g., `6737`)
   - Review ID (e.g., `3741755454`)

2. Run the required fetch described above:
   ```bash
   gh-review-threads OWNER REPO PR_NUMBER REVIEW_ID
   ```
   Threads are already filtered to the target review ID. Do not re-fetch or
   supplement this with other comment APIs.

3. **CRITICAL: Read the ENTIRE reply thread for each comment.**

   The PR author may have responded to reviewer suggestions with important context about:
   - Why a suggestion isn't viable or applicable
   - Technical constraints that make a change inappropriate
   - Clarifications that modify or narrow the original request
   - Agreements, disagreements, or alternative approaches

   **The PR author's replies take precedence over the original reviewer suggestion.**

4. Create a todo list of all the changes requested in the review comments. **Skip any comments that are already resolved** (threads marked `[RESOLVED]` in the output).

5. For each unresolved comment:
   - **First, read the ENTIRE reply thread** - the PR author's replies take precedence over the original suggestion
   - Read the file and line(s) referenced in the comment
   - If the PR author has pushed back on a suggestion with valid reasoning, **respect that decision and skip the change**
   - If the PR author proposed an alternative approach, implement that instead
   - If the PR author asked for clarification and the reviewer agreed/modified their request, follow the updated guidance
   - If a reply indicates the issue was already addressed or is no longer needed, skip it
   - Only if there's no pushback: understand the feedback and make the necessary code changes
   - Mark the todo as complete (or skipped with reason)

6. After all changes are made, commit them with a message like:
   ```
   Address PR review feedback

   - Summary of changes made
   ```
   Append the `Co-Authored-By:` trailer for the model you are currently running as.

7. Push the changes to the remote branch.

8. Reply to each review comment and resolve the thread.

   **IMPORTANT: Do NOT add a leading comment/description before each call. Just call the tool directly — adding a comment before each Bash invocation causes an interactive approval prompt for every single comment, preventing autonomous execution.**

   For each thread:
   ```bash
   gh-resolve-thread OWNER REPO PR_NUMBER COMMENT_ID THREAD_ID "Done - [brief description of change made]"
   ```

   - `COMMENT_ID`: the `commentId` from the first comment in the thread (from the `gh-review-threads` output)
   - `THREAD_ID`: the `threadId` from the thread header (e.g., `PRRT_kwDO...`)
   - Both values come from the step 2 output. If you don't have them, you skipped
     step 2 — go back and run it; do not go hunting for IDs via `gh api`.
   - Run all threads' resolve calls in parallel (multiple Bash tool calls in one response) for efficiency.

9. Report a summary of all changes made and comments addressed.

10. **Copilot Re-Review Notification**: If the reviewer is GitHub Copilot (check if the review author is `copilot` or `github-actions[bot]` with Copilot context):
    - After pushing changes, request Copilot's review again:
      ```bash
      gh pr edit PR_NUMBER --add-reviewer @copilot
      ```
    - **Wait for Copilot's review using a background task.** Use Bash with `run_in_background: true` to poll:
      ```bash
      sleep 600 && gh api repos/OWNER/REPO/pulls/PR_NUMBER/reviews --jq '.[] | select(.user.login == "copilot" or .user.login == "github-actions[bot]") | select(.state != "APPROVED") | .id' | tail -1
      ```
      (This poll for a *new review ID* is the one permitted `gh api` call in this
      workflow. Once you have a new review ID, comments for it are still fetched
      with `gh-review-threads`.)
    - After the background task completes, check its output.
    - **Do NOT automatically address Copilot's new comments.** Instead, notify the user:
      - If a new review ID is found with pending comments, tell the user that Copilot has submitted a new review and provide the review URL so they can decide whether to run `/reviewy` again.
      - If Copilot approved or has no new feedback, report that Copilot is satisfied.

## Checklist before you finish

- [ ] `gh-review-threads` was my first tool call, and I did not fetch comments any other way.
- [ ] I read every reply in every unresolved thread before editing code.
- [ ] I skipped threads the author pushed back on, and said so in the summary.
- [ ] Every thread I acted on got a `gh-resolve-thread` reply.
