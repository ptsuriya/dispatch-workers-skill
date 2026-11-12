#!/usr/bin/env bash
# Preflight for the dispatch-workers skill.
# Checks that required skills are installed and lists optional skills and worker CLIs.
# Exit 0 = all required skills present, 1 = something required is missing.
# Works on macOS bash 3.2 (no associative arrays).

# name|install command (source found with `npx skills find <name>`)
REQUIRED="
caveman|npx skills add juliusbrussee/caveman@caveman
ponytail|npx skills add dietrichgebert/ponytail@ponytail
grilling|npx skills add mattpocock/skills@grilling
domain-modeling|npx skills add mattpocock/skills@domain-modeling
grill-with-docs|npx skills add mattpocock/skills@grill-with-docs
to-spec|npx skills add mattpocock/skills@to-spec
to-tickets|npx skills add mattpocock/skills@to-tickets
handoff|npx skills add mattpocock/skills@handoff
code-review|npx skills add mattpocock/skills@code-review
"

OPTIONAL="
wayfinder|npx skills add mattpocock/skills@wayfinder
implement|npx skills add mattpocock/skills@implement
diagnosing-bugs|npx skills add mattpocock/skills@diagnosing-bugs
tdd|npx skills add mattpocock/skills@tdd
"

CLIS="muse codex copilot opencode"

DIRS=".claude/skills .agents/skills $HOME/.claude/skills $HOME/.agents/skills"

have_skill() {
  for d in $DIRS; do
    [ -f "$d/$1/SKILL.md" ] && return 0
  done
  return 1
}

missing=0

echo "== required skills"
while IFS='|' read -r name cmd; do
  [ -z "$name" ] && continue
  if have_skill "$name"; then echo "  ok       $name"; else echo "  MISSING  $name   ->  $cmd"; missing=$((missing + 1)); fi
done <<< "$REQUIRED"

echo "== optional skills"
while IFS='|' read -r name cmd; do
  [ -z "$name" ] && continue
  if have_skill "$name"; then echo "  ok       $name"; else echo "  absent   $name   ->  $cmd"; fi
done <<< "$OPTIONAL"

echo "== worker CLIs (optional, order = cheapest first is your choice)"
for c in $CLIS; do
  if command -v "$c" >/dev/null 2>&1; then echo "  ok       $c"; else echo "  absent   $c"; fi
done

echo
if [ "$missing" -gt 0 ]; then
  echo "FAIL: $missing required skill(s) missing. Install them, then rerun."
  exit 1
fi
echo "PASS: all required skills present."
