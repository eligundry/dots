---
name: pr-loop
description: Spec for building a deterministic PR babysitting loop that watches open PRs on a timer, classifies state with plain rules, sends fix briefs to owner agents, nudges reviewers, and queues merge decisions for the human. Use when the user wants to build, design, or extend a PR loop / PR babysitter / automated PR follow-up system. Source: https://gist.github.com/jalala/b9712efe5085c50dc000c756654a3fc0
disable-model-invocation: true
---

# PR loop: a spec your agent can build from

By Jalal Ashrafi ([@jalalash](https://x.com/jalalash)). Companion to ["Stop babysitting your PRs"](https://x.com/jalalash/status/2122066461007175851), Part 1 of my agent setup. Free to use and adapt. More parts coming: follow [@jalalash](https://x.com/jalalash) on X.

## Prompt for your agent

> Read this whole spec. Then build a PR loop for me that follows it. Ask me first: which code host I use (GitHub, GitLab, Bitbucket), which repos to watch, my working hours and time zone, how my coding agents can be started or messaged, and where I want questions to reach me. Start at trust level L0 (watch and report only). Show me the plan before you write code.

## What it is

A small, deterministic loop that watches your open PRs on a timer. It does the chores (follow up on red builds, review comments, conflicts and silent reviewers) and asks you only when a decision is needed.

The loop itself has no AI in it. It is plain code. It calls an agent only when something needs fixing or writing.

## Principles

1. Separate building from babysitting. Agents that build a change raise the PR and move on. The loop owns the follow-up for every PR.
2. Deterministic first. Fetch state, classify it with plain rules, pick one action. No model in the loop itself.
3. One action per PR per tick. Keep it boring and predictable.
4. Every action is recorded. If it is not in the ledger, it did not happen.
5. Everything has a return address. Every comment, reply and commit an agent makes links back to the session that made it.
6. Humans decide. Merges and judgement calls wait for you.
7. Trust is earned in steps. Start read-only, widen only after it has been right for a while.

## Parts

### 1. Timer
- Run every 10 minutes.
- Outside working hours, fixes and checks go on. Only human-facing actions wait: pings to people, posts under your name, and merges.

### 2. Discovery
- List open PRs you authored in the repos you chose.
- Skip drafts. PRs with no activity for N days: watch only.
- Optional later: PRs where you are a reviewer (see part 10).

### 3. Snapshot per PR
Fetch only facts:
- head commit id
- build status and the failing checks
- unresolved review comments and who wrote them
- conflicts, or how far behind the base branch it is
- the base branch (nudges and merges apply only to PRs into your main branch)
- open tasks, and the draft flag
- approvals, and which reviewers have not approved
- time since the last human review or activity

### 4. Classify (plain rules)
Map the snapshot to one state. Check in this order and stop at the first match:

| Order | State | Action |
|---|---|---|
| 0 | Merged, closed, draft or inactive | Do nothing |
| 1 | Build red, conflict, or a comment asking for changes | ONE combined fix brief to the owner agent |
| 2 | A reviewer asked a question | The owner drafts a reply. Posting it under your name needs your OK until trusted. |
| 3 | Build still running | Wait |
| 4 | "Changes requested" | Wait for the reviewer |
| 5 | Open tasks | Brief to the owner |
| 6 | Green and approved | Ask me to merge (part 8) |
| 7 | No human review yet | Nudge (part 7) |
| 8 | Review answered, then silence | Re-review nudge (part 7) |
| 9 | Anything else | Waiting for approval |

One action per PR per tick. Note that "approved" is checked before nudges.

A red build first gets a triage step: rerun (flaky) or fix. If the failure comes from another team's flaky test, do not patch around it. Tell me and the owning team.

### 5. The ledger
One record per action. Suggested fields:
- PR, head commit id, state, action, who acted (loop, which agent, or me), time, outcome
- a status: sending, done, failed or superseded
- a dedupe key: action + PR + head commit + item ids (the comment or task ids). A new comment on the same commit gets its own brief, and the same work is never sent twice.

Mark an action sent only after the send succeeds. A new push changes the head commit, so older open actions become superseded.

### 6. Owner agent and fix briefs
- Each PR has one owner agent. Look it up in this order: an existing fixer for this PR, then the last return-address link in the PR description (part 9), then your own record of work by branch, then by ticket key. If none is found, start a fresh fixer.
- Send the owner a short brief: what failed, the facts from the snapshot, what "done" means.
- Each brief is a tracked handoff. No progress means a stall alert and one retry.
- Never take over a session a person is running. Offer them a resume link instead.

### 7. Nudging reviewers
- Nudge when a PR has no human review N hours after it opened (we use 4).
- Tag only reviewers who have not approved. Never tag bots. Bots and the PR author never count as a review.
- At most 2 automatic nudges per PR, at least 72 hours apart. Before a third, ask me.
- Re-review nudge: when every review thread is answered and nobody came back. Tag only reviewers who commented, at most one per head commit, with the same N hours between them.
- Working hours only.
- Pick from varied templates and never repeat the last wording used in that channel. Be polite and specific (repo, PR, how long it waited).

### 8. Questions for me
- Merge, decline and approve wait for me as numbered questions in one queue (chat, Slack, a file, whatever I use).
- I answer with a number. If I add a note, the note wins.
- At most one open merge question per PR. A new head commit, a merge or a decline closes the old question. An answer to a closed question is recorded and never acted on.
- Before acting on my answer, fetch the PR again. Refuse if the head changed, the PR already merged, or the build went red, and tell me why. Just before a merge, re-check for open blocking review findings.

### 9. Risk block and return address
Every PR description carries:
- a risk grade: low, medium or high. The grade comes from what the change touches, not its size. Auth, secrets, data loss, releases and feature flag defaults are always high.
- for medium and high: a blast radius (what could break, for whom, how to revert)
- a link back to the session of the agent that owns it (the loop reads this link to find the owner; no separate owner field needed)

Every comment, reply and commit an agent posts ends with the same link back. The risk grade is for people and reviewers; the loop itself does not need to read it.

### 10. Optional: reviewer side
For PRs where you are a reviewer, a separate reviewer agent:
- reviews each new head commit against what the ticket and the PR promise
- checks live state (build, other approvals) just before acting
- may approve alone only on PRs where you are a reviewer, after re-checking that the build is green on that head commit, and only for low risk
- medium risk: approve only after its findings are fixed and another human approved
- high risk: always asks you
- reviews once per new head commit

## Trust ladder

Start every agent at L0. Move up only after it has been right for a while.

| Level | What it may do |
|---|---|
| L0 | Write reviews and plans locally. Post nothing. |
| L1 | Post comments after I pick a number. |
| L2 | Comment directly. Approve only on my number. |
| L3 | Approve low-risk PRs alone (green build, no open tasks, no "changes requested"). |

For the loop's own actions: fix briefs are automatic from day one, because they never post as you. Then widen to low-risk replies on your own PRs. Then a per-repo merge policy, off by default: green build, a quiet period, the review bot ran on the current head, and no open blocking finding. Expect the safety rules to refuse merges at first; ours has not merged by policy yet. Even after a merge: merged is not shipped. Use staging or an internal release channel before stable.

## Safety rules

- High-risk paths always come to a human.
- No action on a stale snapshot. Re-fetch before acting.
- One owner per PR. No two agents fixing the same PR.
- No pings outside working hours.
- A kill switch: one flag that stops all actions and leaves watch-only.
- A review bot finding blocks the merge unless it is marked low or clean. It clears only with a new commit plus the author's reply in that thread.
- No silent blockers. Every blocked PR must have work in flight, a scheduled next step, or a flag for you. The loop reports any that have none.
- Chases belong to one head commit. A new head starts fresh.

## Build order

1. Timer, discovery, snapshot, classify, ledger. Report only.
2. Fix briefs for red builds.
3. Review comments and conflicts.
4. Nudges.
5. Numbered questions and merge.
6. Climb the trust ladder slowly.

## Measure

Count per week: PRs handled, fix briefs sent, nudges, questions asked, and how often you had to step in. Count unique actions (ledger keys), never raw log rows: updated rows double-count. If stepping in goes down and nothing breaks, widen trust one step.
