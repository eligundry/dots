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

2. Fetch the review and its comments using the GitHub API:
   ```bash
   gh api repos/OWNER/REPO/pulls/PR_NUMBER/reviews/REVIEW_ID
   gh api repos/OWNER/REPO/pulls/PR_NUMBER/reviews/REVIEW_ID/comments
   ```

3. Also fetch the general PR review comment body (the top-level review summary) from the review endpoint.

4. Fetch all PR comments to get reply threads for context:
   ```bash
   gh api repos/OWNER/REPO/pulls/PR_NUMBER/comments
   ```
   For each review comment, check if there are replies by matching `in_reply_to_id` fields. Read the full conversation thread to understand any clarifications, follow-up questions, or additional context provided in replies.

5. Create a todo list of all the changes requested in the review comments. **Skip any comments that are already resolved** (check the `isResolved` or resolution status in the thread).

6. For each unresolved comment:
   - Read the file and line(s) referenced in the comment
   - Consider the full reply thread context (replies may clarify, modify, or resolve the original feedback)
   - If a reply indicates the issue was already addressed or is no longer needed, skip it
   - Understand the feedback being given
   - Make the necessary code changes to address the feedback
   - Mark the todo as complete

7. After all changes are made, commit them with a message like:
   ```
   Address PR review feedback

   - Summary of changes made

   Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>
   ```

8. Push the changes to the remote branch.

9. Reply to each review comment and resolve the thread:
   ```bash
   # Reply to the comment
   gh api repos/OWNER/REPO/pulls/PR_NUMBER/comments/COMMENT_ID/replies -f body="Done - [brief description of change made]"

   # Resolve the comment thread (requires GraphQL)
   gh api graphql -f query='mutation { resolveReviewThread(input: {threadId: "THREAD_NODE_ID"}) { thread { isResolved } } }'
   ```
   To get the thread node ID, fetch the comment and use its `node_id` field, or query the PR review threads via GraphQL.

10. Report a summary of all changes made and comments addressed.

11. **Copilot Auto-Review Loop**: If the reviewer is GitHub Copilot (check if the review author is `copilot` or `github-actions[bot]` with Copilot context):
    - After pushing changes, request Copilot's review again:
      ```bash
      gh pr edit PR_NUMBER --add-reviewer @copilot
      ```
    - Then poll for Copilot's next review using:
      ```bash
      gh api repos/OWNER/REPO/pulls/PR_NUMBER/reviews --jq '.[] | select(.user.login == "copilot" or .user.login == "github-actions[bot]") | select(.state != "APPROVED") | .id' | tail -1
      ```
    - Wait 30-60 seconds between polls (Copilot needs time to analyze changes)
    - If a new review ID is found with pending comments:
      1. Run `/compact` to reduce context
      2. Recursively invoke `/reviewy` with the new review URL: `https://github.com/OWNER/REPO/pull/PR_NUMBER#pullrequestreview-NEW_REVIEW_ID`
    - Continue looping until Copilot approves or has no new feedback
    - Report the final status when the loop completes
