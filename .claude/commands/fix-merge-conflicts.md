# Fix Merge Conflicts

Resolve merge conflicts on the current branch by pulling in the latest changes from the base branch, understanding intent from both sides, and fixing all conflicts.

## Arguments

$ARGUMENTS

The argument may be:
- A target branch name to merge from (e.g., `main`, `develop`, `origin/main`)
- Empty, in which case the default branch is detected automatically

## Instructions

1. **Detect the current state and branches**:
   - Run `git status` to check if there are already unresolved merge conflicts (from a prior failed merge/rebase).
   - Run `git branch --show-current` to get the current branch name.
   - If no target branch was provided in the arguments, detect the default branch:
     ```bash
     git remote show origin | grep 'HEAD branch' | awk '{print $NF}'
     ```
   - If already in a conflicted state from a prior merge, skip to step 3.

2. **Gather context from both sides before merging**:
   - Get the current branch's commits since it diverged from the target branch:
     ```bash
     git log --oneline TARGET_BRANCH..HEAD
     ```
   - Get the target branch's commits since the current branch diverged:
     ```bash
     git fetch origin && git log --oneline HEAD..origin/TARGET_BRANCH
     ```
   - If this branch has an associated PR, fetch its description for additional context:
     ```bash
     gh pr view --json title,body,number --jq '"\(.number): \(.title)\n\(.body)"'
     ```
   - Take note of what each side was trying to accomplish — this context is critical for making correct conflict resolution decisions.

3. **Merge the target branch**:
   - If not already in a conflicted state, run:
     ```bash
     git merge origin/TARGET_BRANCH
     ```
   - If the merge completes cleanly with no conflicts, report success and stop.
   - If there are conflicts, continue to the next step.

4. **Identify all conflicted files**:
   ```bash
   git diff --name-only --diff-filter=U
   ```

5. **Resolve each conflicted file**:
   For each conflicted file:
   - **Lock file special case**: If the conflicted file is a JavaScript/Node lock file (`package-lock.json`, `pnpm-lock.yaml`, `yarn.lock`, or `bun.lockb`), do NOT resolve it manually. Instead:
     1. Accept the incoming version: `git checkout --theirs <lockfile>`
     2. Stage it: `git add <lockfile>`
     3. Run the appropriate package manager install to regenerate it:
        - `package-lock.json` → `npm install`
        - `pnpm-lock.yaml` → `pnpm install`
        - `yarn.lock` → `yarn install`
        - `bun.lockb` → `bun install`
     4. Stage the regenerated lock file: `git add <lockfile>`
     5. Skip to the next conflicted file.
   - Read the file to see the conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`)
   - For each conflict within the file, use the commit context from step 2 to understand:
     - What the current branch's changes were trying to accomplish
     - What the incoming changes were trying to accomplish
     - Whether one side's changes supersede the other, or both need to be combined
   - Resolve the conflict by editing the file to remove all conflict markers and produce correct, working code that preserves the intent of both sides
   - If both sides modified the same logic in incompatible ways, prefer the approach that aligns with the current branch's PR/goal while incorporating the target branch's changes where they don't conflict with that goal
   - After editing, verify no conflict markers remain in the file

6. **Verify the resolution**:
   - Run `grep -r '<<<<<<<' .` on the working directory to ensure no conflict markers remain in any file
   - Stage all resolved files: `git add <resolved files>`

7. **Commit the merge**:
   Create a merge commit with a descriptive body summarizing the resolutions:
   ```
   Merge TARGET_BRANCH into CURRENT_BRANCH

   Conflict resolutions:
   - path/to/file1: brief description of how the conflict was resolved
   - path/to/file2: brief description of how the conflict was resolved

   Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>
   ```

   The conflict resolution descriptions should be concise (one line each) and explain the "what" and "why" — e.g., "kept both the new validation from main and the field rename from this branch" or "used this branch's updated API signature with main's new error handling".

8. Report the result: list the files that had conflicts and how each was resolved.
