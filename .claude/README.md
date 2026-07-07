# Claude Code Project Setup

This directory contains Claude Code-specific project configuration.

## Layout

- `../CLAUDE.md`: project memory entry point. It imports `../AGENTS.md` so
  Claude Code and Codex share one source of truth.
- `settings.json`: shared project settings and safety denials.
- `rules/`: path-scoped Claude Code rules.

## Why There Is No `.claude/CLAUDE.md`

Claude Code supports either a root `CLAUDE.md` or `.claude/CLAUDE.md` for
project instructions. This project keeps `CLAUDE.md` at the repository root so
it is easy to see and can import `AGENTS.md`. Adding a second
`.claude/CLAUDE.md` would risk duplicate or conflicting instructions.

## Local Overrides

Use `.claude/settings.local.json` for personal or machine-specific settings.
Do not commit local credentials, API keys, or private MCP configuration.
