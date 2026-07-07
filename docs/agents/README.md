# Agent Handbook

This directory is the shared onboarding pack for coding agents working on this
Flutter template. Root-level `AGENTS.md` is the concise instruction file that
Codex reads automatically. Root-level `CLAUDE.md` imports `AGENTS.md` for Claude
Code and adds Claude-specific notes.

Claude Code-specific configuration lives in `.claude/`:

- `.claude/settings.json`: project-level permissions and safety defaults.
- `.claude/rules/`: path-scoped instructions for Flutter, architecture, codegen,
  tests, and docs.
- `.claude/README.md`: short guide for local Claude Code usage.

## Quick Orientation

- App entry point: `lib/main.dart`
- DI bootstrap: `lib/core/di/injection.dart`
- Generated DI config: `lib/core/di/injection.config.dart`
- Router: `lib/core/navigation/app_router.dart`
- Route constants: `lib/core/navigation/routes/app_routes.dart`
- Auth feature: `lib/features/auth/`
- Shared widgets/theme: `lib/shared/`
- Tests: `test/`
- Windows scripts: `scripts/`

## Agent Startup Checklist

1. Read `AGENTS.md`.
2. Read this handbook when task scope is unclear.
3. For Claude Code, read `.claude/README.md` and the matching files in
   `.claude/rules/`.
4. For architecture work, read `docs/agents/architecture.md`.
5. For repeat context and decisions, read `docs/agents/memory.md`.
6. For task-specific workflow selection, read `docs/agents/skills.md`.
7. Run `git status --short` before editing and before final summary.

## Standard Verification

```powershell
.\scripts\quality-check.ps1
.\scripts\test.ps1
```

Equivalent FVM commands:

```bash
fvm flutter analyze
fvm dart format lib test --set-exit-if-changed
fvm flutter test
```

## Documentation Policy

- Keep `AGENTS.md` short and operational.
- Keep stable architecture facts here under `docs/agents/`.
- Do not store secrets, tokens, local paths outside the repo, or personal account
  credentials in project docs.
- Prefer concrete commands and paths over broad advice.
