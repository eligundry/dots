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

2. **Fetch all review threads, comments, and replies in a single GraphQL query**:
   ```bash
   gh api graphql -f query='
   query($owner: String!, $repo: String!, $pr: Int!) {
     repository(owner: $owner, name: $repo) {
       pullRequest(number: $pr) {
         reviewThreads(first: 100) {
           nodes {
             id
             isResolved
             comments(first: 50) {
               nodes {
                 id
                 databaseId
                 body
                 path
                 line
                 author { login }
                 createdAt
                 pullRequestReview {
                   databaseId
                 }
               }
             }
           }
         }
       }
     }
   }' -f owner=OWNER -f repo=REPO -F pr=PR_NUMBER
   ```

   This single query returns:
   - All review threads with their `isResolved` status
   - All comments and replies in each thread (chronologically)
   - The `pullRequestReview.databaseId` to filter by the target REVIEW_ID
   - File path and line number for each comment

3. **Filter threads to the target review**: Only process threads where at least one comment has `pullRequestReview.databaseId` matching the REVIEW_ID from the URL.

4. **CRITICAL: Read the ENTIRE reply thread for each comment.**

   The PR author may have responded to reviewer suggestions with important context about:
   - Why a suggestion isn't viable or applicable
   - Technical constraints that make a change inappropriate
   - Clarifications that modify or narrow the original request
   - Agreements, disagreements, or alternative approaches

   **The PR author's replies take precedence over the original reviewer suggestion.**

5. Create a todo list of all the changes requested in the review comments. **Skip any comments that are already resolved** (check the `isResolved` or resolution status in the thread).

6. For each unresolved comment:
   - **First, read the ENTIRE reply thread** - the PR author's replies take precedence over the original suggestion
   - Read the file and line(s) referenced in the comment
   - If the PR author has pushed back on a suggestion with valid reasoning, **respect that decision and skip the change**
   - If the PR author proposed an alternative approach, implement that instead
   - If the PR author asked for clarification and the reviewer agreed/modified their request, follow the updated guidance
   - If a reply indicates the issue was already addressed or is no longer needed, skip it
   - Only if there's no pushback: understand the feedback and make the necessary code changes
   - Mark the todo as complete (or skipped with reason)

7. After all changes are made, commit them with a message like:
   ```
   Address PR review feedback

   - Summary of changes made

   Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>
   ```

8. Push the changes to the remote branch.

9. Reply to each review comment and resolve the thread.

   **IMPORTANT: Do NOT add a leading comment/description before each `gh api` call. Just call the tool directly — adding a comment before each Bash invocation causes an interactive approval prompt for every single comment, preventing autonomous execution.**

   **IMPORTANT: Do NOT use command substitution (`$(...)` or backticks) when constructing these calls. Hard-code the values extracted from the earlier GraphQL query directly into each command.**

   For each thread, run two commands sequentially (chained with `&&`):
   ```bash
   gh api repos/OWNER/REPO/pulls/PR_NUMBER/comments/COMMENT_DATABASE_ID/replies -f body="Done - [brief description of change made]" && gh api graphql -f query='mutation { resolveReviewThread(input: {threadId: "THREAD_ID"}) { thread { isResolved } } }'
   ```

   - `COMMENT_DATABASE_ID`: the `databaseId` from the first comment in the thread (from the initial GraphQL query)
   - `THREAD_ID`: the thread's `id` from the initial GraphQL query (e.g., `PRRT_kwDO...`)
   - Run all threads' reply+resolve calls in parallel (multiple Bash tool calls in one response) for efficiency.

10. Report a summary of all changes made and comments addressed.

11. **Copilot Re-Review Notification**: If the reviewer is GitHub Copilot (check if the review author is `copilot` or `github-actions[bot]` with Copilot context):
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
