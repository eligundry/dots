# Address PR Review Comments

Fetch comments from a specific GitHub PR review and address the requested changes.

## Arguments

$ARGUMENTS

The argument is optional. It may be:

- A GitHub PR **review** URL —
  `https://github.com/OWNER/REPO/pull/PR_NUMBER#pullrequestreview-REVIEW_ID`
  (e.g. `https://github.com/org/repo/pull/6737#pullrequestreview-3741755454`)
- A GitHub **PR** URL — `https://github.com/OWNER/REPO/pull/PR_NUMBER`
- Nothing at all — the PR for the current branch is used.

Only the first form names a single review. For the other two, address **every**
review on the PR that still has unresolved threads.

## REQUIRED FIRST ACTION — do this before anything else

Parse whatever the argument gives you (OWNER, REPO, PR_NUMBER, and REVIEW_ID), then
make one of these Bash calls your **first tool call of the entire task**:

**If you were given a review URL:**

```bash
gh-review-threads OWNER REPO PR_NUMBER REVIEW_ID
```

**If you were given a PR URL or no argument at all** (and always when running in
a loop):

```bash
gh-unresolved-reviews [OWNER REPO PR_NUMBER]
```

`gh-unresolved-reviews` finds every review on the PR with at least one
*unresolved* thread and prints, for each, a header (unresolved count, reviewer,
review state, `reviewId`, review URL) followed by that review's threads in the
exact `gh-review-threads` format — it shells out to `gh-review-threads
--unresolved-only` internally. One call gives you everything; do not follow it
with per-review `gh-review-threads` calls. With no positional args it resolves
the PR from the current branch. `--list` prints only the headers (useful for a
quick "is this PR clean?" check). It exits with a "No unresolved review threads"
line when there is nothing to do.

`gh-review-threads` and `gh-unresolved-reviews` are installed executables at `~/.local/bin/`, already on PATH. They wrap the GitHub GraphQL API and return a compact,
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

If `gh-review-threads` / `gh-unresolved-reviews` errors or is genuinely missing, **stop and tell the user**
rather than falling back to `gh api`. Do not work around it.

## When running in a loop

If this command is being run on a loop (e.g. via `/loop`, a babysitting task, or
repeated invocations against the same PR), **consider all reviewers, not just the
review ID in the URL you were given.**

- Before finishing an iteration, run `gh-unresolved-reviews` to check the PR for
  review threads from *any* reviewer — human teammates, GitHub Copilot,
  CodeRabbit, and any other bot — that are still unresolved, including reviews
  submitted after the one you were pointed at.
- Pick up those threads in the same pass rather than waiting for the user to hand
  you another review URL. `gh-unresolved-reviews` already returns each additional
  review's threads inline, so no extra fetch is needed (the `gh api` prohibition
  above still applies).
- Apply the same rules to them: read the full thread, respect the PR author's
  pushback, skip resolved threads.
- Only report the PR as clean when there are no unresolved threads left from any
  reviewer.

## Instructions

1. Parse the argument (if any) to extract owner and repo (e.g. `org/repo`), PR
   number (e.g. `6737`), and review ID (e.g. `3741755454`) when present.

2. Run the required fetch described above — `gh-review-threads` for a single
   review URL, otherwise `gh-unresolved-reviews`. Threads come back already
   filtered (to the target review ID, or to unresolved threads across all
   reviews). Do not re-fetch or supplement this with other comment APIs.

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

- [ ] `gh-review-threads` or `gh-unresolved-reviews` was my first tool call, and I did not fetch comments any other way.
- [ ] I read every reply in every unresolved thread before editing code.
- [ ] I skipped threads the author pushed back on, and said so in the summary.
- [ ] Every thread I acted on got a `gh-resolve-thread` reply.
- [ ] If I'm running in a loop — or wasn't handed a specific review URL — I used
      `gh-unresolved-reviews` so every reviewer's unresolved threads were covered,
      not just one review ID.
