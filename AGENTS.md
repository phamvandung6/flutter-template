# Agent Instructions

These instructions are shared project guidance for Codex and other coding
agents. Keep this file concise; put longer background in `docs/agents/`.

## Project Snapshot

- Flutter boilerplate pinned by FVM to Flutter `3.44.5` and Dart `3.12.2`.
- Architecture: Clean Architecture with `core/`, `features/`, and `shared/`.
- State management: Cubit-first with BLoC for event-driven flows, using reusable
  base view state classes for simple async screens.
- DI: GetIt + Injectable.
- Navigation: GoRouter.
- Networking: Dio + Retrofit, with DTOs in the data layer.
- Models/codegen: Freezed, json_serializable, retrofit_generator, injectable_generator.
- Result style: `dartz` `Either` via `ResultFuture` / `ResultVoid`.

## Must-Read Context

- `README.md`: setup, commands, architecture summary.
- `CLAUDE.md`: Claude Code entry point that imports this file.
- `.claude/README.md`: Claude Code project layout and local override notes.
- `.claude/settings.json`: Claude Code project permissions and safety defaults.
- `.claude/rules/`: Claude Code path-scoped rules for Flutter, architecture,
  codegen, tests, and docs.
- `docs/agents/README.md`: agent handbook and task workflow.
- `docs/agents/architecture.md`: architecture map and feature flow.
- `docs/agents/skills.md`: recommended agent skills by task type.
- `docs/agents/memory.md`: project memory policy and current facts.

## Required Workflow

1. Inspect existing patterns before editing.
2. Keep changes scoped to the requested feature/fix.
3. Do not edit generated files directly.
4. Run code generation after changing Freezed, JSON, Retrofit, or Injectable inputs.
5. Run analyzer and tests before declaring work complete.

## Commands

Prefer FVM commands. On Windows, use the PowerShell scripts.

```bash
fvm flutter pub get
fvm dart run build_runner build
fvm flutter analyze
fvm flutter test
```

```powershell
.\scripts\dev-setup.ps1
.\scripts\quality-check.ps1
.\scripts\test.ps1
```

If `make` is available:

```bash
make dev-setup
make quality-check
make test
```

## Code Standards

- Follow `analysis_options.yaml` and the existing Dart formatter.
- Prefer `const` widgets and small widget classes over large helper methods.
- Avoid `!` unless the invariant is obvious and local.
- Check `mounted` after `await` before using `BuildContext`.
- Use `unawaited(...)` for intentional fire-and-forget futures.
- Use `withValues(alpha: ...)`, not deprecated `withOpacity(...)`.
- Use Freezed models as `abstract class Foo with _$Foo`.
- Keep DTO/entity mapping explicit at data/domain boundaries.

## Architecture Rules

- `features/<feature>/domain`: entities, repository contracts, use cases.
- `features/<feature>/data`: DTOs, data sources, repository implementations.
- `features/<feature>/presentation`: BLoC/Cubit, state/events, pages/widgets.
- `core/`: app-wide config, shared domain primitives, DI, navigation, networking, error handling, utilities.
- `shared/`: reusable theme, widgets, base BLoC/Cubit primitives.
- Do not make UI depend directly on remote/local data sources.
- Do not make domain depend on Flutter, Dio, Retrofit, or storage.
- Prefer Cubit for simple presentation/application state.
- Use BLoC when explicit events, traceability, or event transformers are useful.
- Keep domain business rules in use cases, not in Cubit/BLoC.
- Do not add `flutter_hooks` by default. Add it only when a feature needs
  reusable local widget lifecycle helpers.
- If hooks are introduced, keep them presentation-only and never use them as a
  replacement for Cubit/BLoC feature state.

## Dependency And Codegen Rules

- Ask before adding new production dependencies.
- Prefer existing packages already in `pubspec.yaml`.
- `flutter_hooks` is optional; add it only for concrete UI lifecycle needs such
  as controllers, local animations, or reusable debounced input helpers.
- Other optional packages are cataloged in `docs/agents/architecture.md`; do not
  add them until a real feature justifies the dependency.
- After dependency changes, run `fvm flutter pub get`.
- After generator input changes, run `fvm dart run build_runner build`.
- Branding generators use example configs in `tool/branding/`; run them only
  after real project icon/splash assets exist.
- Generated files are gitignored; fresh clones must run setup/codegen.

## Testing Rules

- Put tests under `test/` mirroring the source area when practical.
- Use `bloc_test` for BLoC/Cubit behavior.
- Use `mocktail` fakes/mocks for dependencies.
- Keep smoke tests initializing `AppConfig` and `configureDependencies()`.
- Minimum verification for code changes: analyzer + relevant tests.

## Git And External Actions

- Do not push, publish, merge, create remote resources, or change credentials
  without explicit user approval.
- Review `git status --short` before summarizing changes.
- Preserve user changes; do not revert unrelated edits.

## Agent Setup

- Codex reads `AGENTS.md`.
- Claude Code reads root `CLAUDE.md`, which imports `AGENTS.md`.
- Claude Code project settings live in `.claude/settings.json`.
- Claude Code path-scoped guidance lives in `.claude/rules/`.
- Keep shared instructions in this file first.
- Keep long-lived, non-secret facts in `docs/agents/memory.md`.

## Known Project Notes

- `make` may not be installed on Windows; use scripts in `scripts/`.
- `AuthRepositoryImpl.isAuthenticated` and `currentUser` are placeholders.
- Several routes in `AppRouter` intentionally render placeholder pages.
- GitHub push may fail if the active credential is not the repo owner account.
