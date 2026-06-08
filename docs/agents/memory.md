# Project Memory

This file stores stable team-shared facts an agent should remember across
sessions. It is not a scratchpad and must not contain secrets.

## Stable Facts

- The project is a Flutter boilerplate, not a finished product app.
- Flutter is pinned with FVM in `.fvmrc` to `3.44.1`.
- Generated files are ignored by git; run codegen after a fresh clone.
- Windows machines may not have `make`; use `scripts/*.ps1` as the portable path
  for this repo owner.
- Analyzer and tests were verified after the template cleanup:
  - `fvm flutter analyze`
  - `fvm flutter test`
  - `.\scripts\quality-check.ps1`
  - `.\scripts\test.ps1`
  - `.\scripts\dev-setup.ps1`
- Direct dependencies were up to date at the last cleanup; remaining outdated
  packages were transitive constraints from Flutter/tooling.

## Decisions

- Use `AGENTS.md` as the primary shared instruction file for Codex.
- Use `CLAUDE.md` as a Claude Code shim that imports `AGENTS.md`.
- Keep Claude Code-specific settings in `.claude/settings.json`.
- Keep Claude Code path-scoped rules in `.claude/rules/`.
- Do not add `.claude/CLAUDE.md`; keep root `CLAUDE.md` as the single Claude
  entry point to avoid duplicate top-level instruction sources.
- Keep long details in `docs/agents/` so root instruction files remain concise.
- Keep lint strict for correctness but relaxed for boilerplate ergonomics.
- Prefer explicit DTO/entity mapping instead of leaking data-layer types into
  domain or presentation layers.
- Use Cubit by default for simple presentation/application state.
- Use BLoC for event-driven flows that need traceability, event transformers, or
  multiple action sources.
- Keep domain business rules in use cases, not in Cubit/BLoC.
- Keep `BaseBlocEvent` minimal; feature-specific events should live with each
  feature instead of relying on generic refresh/reset/retry events.
- Do not include `flutter_hooks` by default. Add it only when a concrete feature
  needs reusable local widget lifecycle helpers.
- If hooks are introduced, keep them presentation-only and do not use them as a
  replacement for Cubit/BLoC feature state.
- Keep generated files out of git to reduce template noise.

## Do Not Store Here

- GitHub tokens, API keys, passwords, signing credentials, or private endpoints.
- Local machine-only preferences.
- Temporary task state that belongs in the current conversation.
- Speculation that is not verified in the repo.

## When To Update

Update this file when:

- A project-wide decision changes.
- A repeated mistake should be prevented in future sessions.
- A setup gotcha affects more than one contributor or agent.
- A command or workflow changes.
