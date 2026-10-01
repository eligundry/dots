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
PR description, every **existing unresolved review thread**, and the full diff
annotated with the exact line numbers the review API accepts:

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
  `gh pr view`, `gh pr diff`, or `gh api` calls.
- `gh-pr-file OWNER REPO REF PATH` — a file at a ref, with line numbers. Use it
  with the head SHA to read surrounding code. If the current directory is a
  checkout of this repo and `git rev-parse HEAD` equals the head SHA, just read
  the local files instead.
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
   tell the user and stop unless they asked anyway.

2. **Correctness review.** Go through the diff file by file. Read the
   surrounding code (`gh-pr-file` or local files) whenever a hunk's behavior
   depends on code you can't see: callers, types, the rest of the function.
   Look for:
   - bugs: wrong logic, off-by-one, null/undefined paths, broken error
     handling, race conditions, wrong async/await usage
   - security: injection, authz gaps, secrets, unsafe input handling
   - data: lost writes, destructive or irreversible migrations, broken API or
     schema contracts
   - the PR not doing what its description says, or doing more than it says
   - missing tests for risky new logic

   Verify each suspicion against the actual code before you write it up. If you
   still can't confirm it, phrase it as a question instead of a claim.

3. **Over-engineering review (ponytail).** Read
   `~/.agents/skills/ponytail-review/SKILL.md` and apply it to the same diff:
   reinvented stdlib, unneeded dependencies, speculative abstractions, dead
   flexibility. Skip its one-line output format and `net:` score. Each finding
   becomes a line comment in this review, written as a nit (see below). Under
   Claude Code you may run this pass in a parallel sub-agent while you do step 2.

4. **Classify every finding** and prefix its comment with the label:
   - `**blocking:**` — a real bug, security hole, data-loss risk, broken
     contract, or a PR that doesn't do what it claims. Serious enough that it
     must not merge as is.
   - `**nit:**` — style, naming, readability, small simplifications, every
     ponytail finding, and missing tests for low-risk code.
   - `**question:**` — something you couldn't verify. A question never blocks
     on its own.

   Be strict about `blocking`. If it's a matter of taste, it's a nit.

5. **Write the line comments.** One finding per comment, on the most specific
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

6. **Write the review body. Overall commentary only.** A few sentences: what
   the PR does well, the overall assessment, and any cross-cutting concern or
   out-of-diff finding. Do **not** restate the line comments or list them.
   Don't add a bot disclaimer; `gh-submit-review` appends one.

7. **Pick the verdict:**
   - any `blocking` finding → `REQUEST_CHANGES`
   - otherwise → `APPROVE`, even when there are nits and questions. The body
     should say the nits are optional.
   - The PR author is you (`[SELF-REVIEW]`) → pick the verdict as above anyway;
     the script downgrades it to `COMMENT` and states the verdict in the body.

8. **Write the review JSON** with your file-writing tool (not a shell heredoc)
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

9. **Submit:**

   ```bash
   gh-submit-review OWNER REPO PR_NUMBER /path/to/review.json
   ```

   (Add `--dry-run` in draft mode.) The review is atomic: if GitHub rejects it
   (usually a 422 for a line that isn't in the diff), nothing was posted. Fix
   the offending comment's `path`/`line`/`side` against the annotated diff, or
   move that finding into the body, and submit again.

10. **Report** to the user: the verdict, the review URL from the script's
    output, and a short list of the findings, blocking ones first.

## Checklist before you finish

- [ ] `gh-pr-review-context` was my first tool call, and I didn't fetch the PR any other way.
- [ ] I ran the ponytail-review pass and its findings went in as nits.
- [ ] Every line comment is on a line from the annotated diff, labeled blocking / nit / question.
- [ ] The body is overall commentary only and doesn't repeat line comments.
- [ ] `REQUEST_CHANGES` only if there's at least one `blocking`; otherwise `APPROVE`.
- [ ] The whole review went out in one `gh-submit-review` call.
