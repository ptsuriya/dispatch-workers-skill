# Worker CLIs

Flags change between versions. Run `<cli> --help` once before the first dispatch and
adjust. Every worker is optional; `scripts/preflight.sh` tells you which ones exist.

## Rules that apply to all of them

- Write the prompt to a file (heredoc with a quoted delimiter, `<<'EOF'`), then pass it as
  `"$(cat prompt.md)"` or `--prompt-file`. A prompt inside double quotes gets mangled by the shell
  (backticks and `$(...)` are expanded).
- Redirect stdin from `/dev/null`, otherwise some CLIs hang waiting for input.
- Redirect output to a file (`> out.txt 2>&1`) and read the file. Check it is not empty.
- Run from the repository root of the project being changed. A wrong working directory can
  produce "+0 -0" results with no error.
- Workers usually cannot or should not commit. The orchestrator commits.
- Quota can run out mid-task and leave only the echoed prompt behind. Treat a truncated report as failed.

## Typical invocations

| CLI | Typical form |
|---|---|
| muse | `muse exec --workspace "$PWD" --prompt-file prompt.md < /dev/null > out.txt 2>&1` |
| codex | `codex exec "$(cat prompt.md)" < /dev/null > out.txt 2>&1` |
| copilot | `copilot -p "$(cat prompt.md)" < /dev/null > out.txt 2>&1` |
| opencode | `opencode run "$(cat prompt.md)" < /dev/null > out.txt 2>&1` |

## Sanity check before blaming a worker

Send `Reply with exactly: PONG`. Some CLIs fail silently (empty answer, exit 0). A PONG
proves the CLI works before you conclude it does not.

## Picking a worker

- Simple, well-specified edits and tests: free or cheap CLIs first.
- Anything touching a database in tests: give each worker its own database name.
- Hard design or root-cause work: strongest model, in your own session, not a worker.
- Final review: a different vendor or model than the author.
