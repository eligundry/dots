# Review a Pull Request

Review someone's GitHub PR the way Eli does: line comments on the code, a short
overall verdict in the review body, request changes only for serious problems,
and approve when all that's left is nits.

## Arguments

$ARGUMENTS

The argument is optional. It may be:

- A GitHub PR URL — `https://github.com/OWNER/REPO/pull/PR_NUMBER`
- A bare PR number — a PR in the current repo
- Nothing at all — the PR for the current branch is used.

If the arguments also contain `--draft` (or the user says "draft" / "dry run"),
do everything except post: submit with `--dry-run` and show the user the result.

## REQUIRED FIRST ACTION — do this before anything else

Make one of these Bash calls your **first tool call of the entire task**:

```bash
gh-pr-review-context OWNER REPO PR_NUMBER   # from a URL
gh-pr-review-context PR_NUMBER              # bare number
gh-pr-review-context                        # no argument
```

It prints, in one call: owner/repo/PR, title, author, your login (and a
`[SELF-REVIEW]` flag if you're the author), base/head branches, head SHA, the
PR description, every **existing unresolved review thread**, a `## Checkout`
section (the local checkout of the PR's head commit, from `gh-pr-worktree`),
and the full diff — produced by `git diff <merge-base> HEAD` in that checkout,
not the GitHub API — annotated with the exact line numbers the review API
accepts:

```
  OLD   NEW m | text
   44       - | removed line      -> side LEFT,  line 44
         44 + | added line        -> side RIGHT, line 44
   46    46   | context line      -> side RIGHT, line 46
```

Line comments **must** land on a line that appears in this diff, using those
numbers. Never compute line numbers yourself from a raw file.

### Tools for this task (and nothing else)

These are installed at `~/.local/bin/` and are on PATH:

- `gh-pr-review-context` — above. Run it once; do not supplement it with
  `gh pr view`, `gh pr diff`, `git diff`, or `gh api` calls.
- `gh-pr-worktree` — called for you by `gh-pr-review-context`; don't run it
  yourself except for `gh-pr-worktree --cleanup PATH`. It checks out the PR's
  head commit locally and prints `path:`, `created:`, `cleanup:`, and
  `merge-base:`. If the current
  checkout (or another worktree of the repo) is already at the head commit it
  reuses that and prints `created: no` / `cleanup: none`. Otherwise it adds a
  detached worktree, or makes a temp clone when local Git writes fail or you
  aren't inside the repo, and prints the cleanup command. Read every file from
  that `path`, never through the GitHub API.
- `gh-submit-review OWNER REPO PR_NUMBER REVIEW_JSON [--dry-run]` — posts the
  whole review (verdict, body, every line comment) in one atomic call, pinned to
  the head SHA, with the bot footer appended.

Do **not** post comments one at a time, use `gh pr review`, or hand-roll
`gh api` / GraphQL calls. If a helper errors or is missing, **stop and tell the
user** instead of working around it.

## Instructions

1. **Gather context.** Run `gh-pr-review-context`. Read the description to learn
   what the PR is *supposed* to do. Note the existing unresolved threads so you
   don't repeat a point someone has already raised. If the PR is merged/closed,
   tell the user and stop (after step 11's cleanup) unless they asked anyway.

2. **Use the checkout.** Note the `path` and `cleanup` lines from the
   `## Checkout` section. All file reads and code searches for the rest of the
   review happen in that `path`. Don't run
   `git checkout`, `git switch`, or `git worktree` yourself, and don't change
   files in the checkout.

3. **Correctness review.** Go through the diff file by file. Read the
   surrounding code in the checkout whenever a hunk's behavior depends on code
   you can't see: callers, types, the rest of the function. Grep the checkout for
   other usages of anything the PR renames, removes, or changes the signature
   of. Look for:
   - bugs: wrong logic, off-by-one, null/undefined paths, broken error
     handling, race conditions, wrong async/await usage
   - security: injection, authz gaps, secrets, unsafe input handling
   - data: lost writes, destructive or irreversible migrations, broken API or
     schema contracts
   - the PR not doing what its description says, or doing more than it says
   - missing tests for risky new logic

   Verify each suspicion against the actual code before you write it up. If you
   still can't confirm it, phrase it as a question instead of a claim.

4. **Over-engineering review (ponytail).** Read
   `~/.agents/skills/ponytail-review/SKILL.md` and apply it to the same diff:
   reinvented stdlib, unneeded dependencies, speculative abstractions, dead
   flexibility. Skip its one-line output format and `net:` score. Each finding
   becomes a line comment in this review, written as a nit (see below). Under
   Claude Code you may run this pass in a parallel sub-agent while you do step 3;
   give it the checkout `path`.

5. **Classify every finding** and prefix its comment with the label:
   - `**blocking:**` — a real bug, security hole, data-loss risk, broken
     contract, or a PR that doesn't do what it claims. Serious enough that it
     must not merge as is.
   - `**nit:**` — style, naming, readability, small simplifications, every
     ponytail finding, and missing tests for low-risk code.
   - `**question:**` — something you couldn't verify. A question never blocks
     on its own.

   Be strict about `blocking`. If it's a matter of taste, it's a nit.

6. **Write the line comments.** One finding per comment, on the most specific
   line or line range (`start_line`/`line`) in the annotated diff. Say what's
   wrong and why in a sentence or two, then the fix. When the fix is small and
   replaces exactly the commented lines, use a GitHub suggestion block:

   ````
   ```suggestion
   replacement code
   ```
   ````

   Findings about code *outside* the diff can't be line comments. Put those in
   the body.

7. **Write the review body. Overall commentary only.** A few sentences: what
   the PR does well, the overall assessment, and any cross-cutting concern or
   out-of-diff finding. Do **not** restate the line comments or list them.
   Don't add a bot disclaimer; `gh-submit-review` appends one.

8. **Pick the verdict:**
   - any `blocking` finding → `REQUEST_CHANGES`
   - otherwise → `APPROVE`, even when there are nits and questions. The body
     should say the nits are optional.
   - The PR author is you (`[SELF-REVIEW]`) → pick the verdict as above anyway;
     the script downgrades it to `COMMENT` and states the verdict in the body.

9. **Write the review JSON** with your file-writing tool (not a shell heredoc)
   to a temp location: the scratchpad directory under Claude Code, or
   `${TMPDIR:-/tmp}/eli-review-PR_NUMBER.json` under Codex. Do not write it
   inside the repo.

   ```json
   {
     "event": "APPROVE",
     "body": "Overall commentary…",
     "comments": [
       {"path": "src/a.ts", "line": 42, "body": "**nit:** …"},
       {"path": "src/a.ts", "start_line": 10, "line": 14, "body": "**blocking:** …"},
       {"path": "src/b.ts", "line": 7, "side": "LEFT", "body": "**question:** …"}
     ]
   }
   ```

   `side` defaults to `RIGHT`; set `"LEFT"` only for `-` lines.

10. **Submit:**

    ```bash
    gh-submit-review OWNER REPO PR_NUMBER /path/to/review.json
    ```

    (Add `--dry-run` in draft mode.) The review is atomic: if GitHub rejects it
    (usually a 422 for a line that isn't in the diff), nothing was posted. Fix
    the offending comment's `path`/`line`/`side` against the annotated diff, or
    move that finding into the body, and submit again.

11. **Tear down.** If the `## Checkout` section printed a `cleanup:` command (not `none`), run it.
    Do this however the review ends: after submitting, after a dry run, or when
    you stop early because of an error or a closed PR. Never remove a checkout
    that printed `created: no`.

12. **Report** to the user: the verdict, the review URL from the script's
    output, and a short list of the findings, blocking ones first.

## Checklist before you finish

- [ ] `gh-pr-review-context` was my first tool call, and I didn't fetch the PR any other way.
- [ ] I read code from the checkout `path`, not from the GitHub API.
- [ ] I ran the ponytail-review pass and its findings went in as nits.
- [ ] Every line comment is on a line from the annotated diff, labeled blocking / nit / question.
- [ ] The body is overall commentary only and doesn't repeat line comments.
- [ ] `REQUEST_CHANGES` only if there's at least one `blocking`; otherwise `APPROVE`.
- [ ] The whole review went out in one `gh-submit-review` call.
- [ ] I ran the `cleanup:` command if there was one.
