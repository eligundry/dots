# Address PR Review Comments

Fetch comments from a specific GitHub PR review and address the requested changes.

## Arguments

$ARGUMENTS

The argument should be a GitHub PR review URL in the format:
`https://github.com/OWNER/REPO/pull/PR_NUMBER#pullrequestreview-REVIEW_ID`

Example: `https://github.com/codeclimate/edp/pull/6737#pullrequestreview-3741755454`

## Instructions

1. Parse the URL to extract:
   - Owner and repo (e.g., `codeclimate/edp`)
   - PR number (e.g., `6737`)
   - Review ID (e.g., `3741755454`)

2. Fetch the review comments using the GitHub API:
   ```bash
   gh api repos/OWNER/REPO/pulls/PR_NUMBER/reviews/REVIEW_ID
   gh api repos/OWNER/REPO/pulls/PR_NUMBER/reviews/REVIEW_ID/comments
   ```

3. Also fetch the general PR review comment body (the top-level review summary) from the review endpoint.

4. Create a todo list of all the changes requested in the review comments.

5. For each comment:
   - Read the file and line(s) referenced in the comment
   - Understand the feedback being given
   - Make the necessary code changes to address the feedback
   - Mark the todo as complete

6. After all changes are made, commit them with a message like:
   ```
   Address PR review feedback

   - Summary of changes made

   Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>
   ```

7. Push the changes to the remote branch.

8. Reply to each review comment using the GitHub API to indicate the feedback has been addressed:
   ```bash
   gh api repos/OWNER/REPO/pulls/PR_NUMBER/comments/COMMENT_ID/replies -f body="Done - [brief description of change made]"
   ```

9. Report a summary of all changes made and comments addressed.
