# dispatch-workers

An agent skill: split work into small tickets, hand them to cheap or free worker CLIs and
subagents first, then verify and review the result yourself, then hand off.

It starts with a preflight (`scripts/preflight.sh`) that checks the other skills it relies on
and prints the install command for each one that is missing.

## Install

```bash
npx skills add ptsuriya/dispatch-workers
```

Add `-g` for a user-level install.

## Needs

Required skills: `caveman`, `ponytail`, `grilling`, `domain-modeling`, `grill-with-docs`,
`to-spec`, `to-tickets`, `handoff`, `code-review`.
Optional skills: `wayfinder`, `implement`, `diagnosing-bugs`, `tdd`.
Optional worker CLIs (any subset): `muse`, `codex`, `copilot`, `opencode`.

Check what is missing:

```bash
bash scripts/preflight.sh
```
