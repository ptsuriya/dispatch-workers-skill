---
name: dispatch-workers
description: Plan work in small tickets and hand them to cheap or free worker CLIs and subagents first, then verify and review it yourself. Use when a task is big enough to split across several agents, when the user wants to save tokens, or when asked to dispatch, delegate, orchestrate or hand off work to other sessions.
---

# Dispatch workers

You are the orchestrator. You understand the problem, split it, hand the typing to
cheaper workers, then verify and commit. The goal is fewer expensive tokens, not fewer checks.

## Step 0: preflight (always first)

Run the check script that ships with this skill. Do not start dispatching if it fails.

```bash
bash <this-skill-dir>/scripts/preflight.sh
```

It reports which required skills and optional worker CLIs are installed and prints
the `npx skills add ...` line for each missing skill. Required skills missing means
stop and tell the user which ones to install. Missing worker CLIs are fine: fall
back to the next worker in the order below, and say which were unavailable.

## Rules

### 1. Context first
Read the core yourself before handing anything out: data model, the path data takes
end to end, who can touch what. Workers widen coverage; they do not replace your understanding.
Include in every ticket the context a cold-start worker needs. Never assume it shares your memory.

### 2. Save tokens hard
- Reply in `caveman` style and build with `ponytail` (shortest working diff). Tell workers to do the same.
- Worker order, cheapest first: free/low-cost CLIs (see `references/workers.md`), then a mid-tier model,
  then the strongest model only for design and hard root-cause bugs.
- Long prompts go through a file, never inline in a shell string.
- Do not re-read what a worker already summarised; read the diff instead.

### 3. Understand, then split
- Unclear task: run `grill-with-docs` first (interview, sharpen terms, update the glossary).
- Then `to-spec`, then `to-tickets`.
- Tickets are small: one purpose, named files, its own test, declared blocking edges.
  Independent tickets run in parallel; dependent ones wait.
- Give each worker its own isolated resources (separate test database, own git worktree or
  file set). Two workers editing the same file is a bug in your split.

### 4. Verify yourself
A worker's report is a claim, not a result. For every ticket:
1. Confirm files actually changed (`git status`, `git diff --stat`), not just that the report says so.
2. Rerun build and tests yourself. Green can mean nobody wrote a test: check the test exists and fails when the code is broken.
3. Run only the tests that cover changed code and its neighbours. Tell the user which suites you skipped.
4. Empty or cut-off worker output (exit 0 with nothing, or a quota error) means the ticket is not done.
5. You own git: stage files by name, read `git diff --cached`, commit per ticket. Never `git commit -a`.

### 5. Independent final review
Last step: a different model than the one that wrote the code reviews the diff against
the spec (use `code-review`, or a second worker CLI). Fix findings, rerun the affected tests.

### 6. Close out
Run `handoff` so the next session starts with state, open questions and next ticket.
Do not push or deploy unless the user said so for this change.

## Stop and ask the user when
- A step is irreversible or outward-facing (push, deploy, delete, message sent to others).
- Workers disagree on a design decision that is the user's to make.
- Every cheap worker is out of quota and the remaining work is large.
