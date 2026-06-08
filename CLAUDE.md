@AGENTS.md

## Claude Code Notes

- Claude Code reads `CLAUDE.md`; this file imports `AGENTS.md` so Codex and
  Claude share the same project instructions.
- Use `/memory` to inspect what Claude loaded when behavior seems stale.
- Keep long-lived team facts in `docs/agents/memory.md`, not in chat only.
- Keep this file short. Add detailed project guidance under `docs/agents/`.
- Path-scoped Claude Code rules live in `.claude/rules/`.
- Project-level Claude Code safety defaults live in `.claude/settings.json`.
