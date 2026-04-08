# Codebase Diagnostics

Run a quick diagnostic of the current git repository to understand its health, risks, and dynamics before diving into the code. Based on [Git Commands You Should Run Before Reading Code](https://piechowski.io/post/git-commands-before-reading-code/).

## Arguments

$ARGUMENTS

The argument may be:
- A time range (e.g., `6 months`, `2 years`) to override the default 1-year lookback
- A number for top-N results (e.g., `30` to see top 30 instead of top 20)
- Empty, in which case defaults are used (1 year lookback, top 20)

## Instructions

Run all five diagnostic commands in parallel, then synthesize the results into a single report.

### 1. File Churn Analysis

Find the most-frequently modified files. High-churn files often signal technical debt or instability.

```bash
git log --format=format: --name-only --since="1 year ago" | sort | uniq -c | sort -nr | head -20
```

### 2. Contributor Analysis

Rank contributors by commit count to assess bus factor and team composition.

```bash
git shortlog -sn --no-merges
```

Also run a recent-activity check:
```bash
git shortlog -sn --no-merges --since="6 months ago"
```

### 3. Bug Hotspot Mapping

Find files most frequently touched in bug-fix commits. Cross-reference with churn data to identify highest-risk code.

```bash
git log -i -E --grep="fix|bug|broken" --name-only --format='' | sort | uniq -c | sort -nr | head -20
```

### 4. Velocity Tracking

Show monthly commit counts to reveal team momentum patterns.

```bash
git log --format='%ad' --date=format:'%Y-%m' | sort | uniq -c
```

### 5. Firefighting Frequency

Count reverts, hotfixes, and emergency commits to gauge deployment confidence.

```bash
git log --oneline --since="1 year ago" | grep -iE 'revert|hotfix|emergency|rollback'
```

### Synthesis

After gathering all data, produce a report with these sections:

- **Churn Hotspots**: Top 10 most-changed files with brief risk assessment
- **Bus Factor**: Key contributors, whether original architects are still active, concentration risk
- **Bug Magnets**: Files appearing in both churn and bug-fix lists (highest risk)
- **Project Velocity**: Trend summary (steady, accelerating, declining, erratic) with notable patterns
- **Deployment Confidence**: Revert/hotfix frequency and what it suggests about the release process
- **Key Risks**: 3-5 bullet summary of the most important findings

Keep the report concise and actionable. Flag anything that warrants immediate attention.
