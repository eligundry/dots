# Address PR Review Comments

Fetch comments from a specific GitHub PR review and address the requested changes.

## Arguments

$ARGUMENTS

The argument should be a GitHub PR review URL in the format:
`https://github.com/OWNER/REPO/pull/PR_NUMBER#pullrequestreview-REVIEW_ID`

Example: `https://github.com/org/repo/pull/6737#pullrequestreview-3741755454`

## Instructions

1. Parse the URL to extract:
   - Owner and repo (e.g., `org/repo`)
   - PR number (e.g., `6737`)
   - Review ID (e.g., `3741755454`)

2. **Fetch all review threads for this review**:
   ```bash
   gh-review-threads OWNER REPO PR_NUMBER REVIEW_ID
   ```

   This returns a compact, threaded text format with all comments, replies, file paths, line numbers, thread IDs, and comment database IDs needed for later steps. Threads are already filtered to the target review ID.

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

   Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>
   ```

7. Push the changes to the remote branch.

8. Reply to each review comment and resolve the thread.

   **IMPORTANT: Do NOT add a leading comment/description before each call. Just call the tool directly — adding a comment before each Bash invocation causes an interactive approval prompt for every single comment, preventing autonomous execution.**

   For each thread:
   ```bash
   gh-resolve-thread OWNER REPO PR_NUMBER COMMENT_ID THREAD_ID "Done - [brief description of change made]"
   ```

   - `COMMENT_ID`: the `commentId` from the first comment in the thread (from the `gh-review-threads` output)
   - `THREAD_ID`: the `threadId` from the thread header (e.g., `PRRT_kwDO...`)
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
    - After the background task completes, check its output.
    - **Do NOT automatically address Copilot's new comments.** Instead, notify the user:
      - If a new review ID is found with pending comments, tell the user that Copilot has submitted a new review and provide the review URL so they can decide whether to run `/reviewy` again.
      - If Copilot approved or has no new feedback, report that Copilot is satisfied.
