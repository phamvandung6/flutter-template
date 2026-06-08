# Agent Skills And Workflows

Use this as a routing guide for agent work. If a tool has native skills, load
the smallest relevant skill set before editing.

## Recommended Skills By Task

| Task | Recommended skill/workflow |
| --- | --- |
| Flutter feature work | Dart/Flutter patterns |
| Codebase orientation | Codebase onboarding |
| Tests first or behavior changes | TDD workflow |
| Verification before handoff | Verification loop |
| Security-sensitive auth/storage/networking | Security review |
| Dependency or package docs | Documentation lookup / official docs |
| Branding/icon/splash setup | Flutter patterns plus official package docs |
| UI polish or widgets | Frontend/a11y plus Flutter patterns |

## Flutter Implementation Rules

- Prefer existing project patterns before introducing a new abstraction.
- Keep domain pure: no Flutter, Dio, storage, or Retrofit imports.
- Keep data-layer DTOs and API clients under `features/*/data`.
- Use use cases as the boundary between Cubit/BLoC and repositories.
- Use `Either<Failure, T>` for recoverable domain/data results.
- Prefer Cubit for simple UI/application state.
- Use Bloc when events, traceability, event transformers, or multi-source flows
  make the behavior clearer.
- Treat Cubit/BLoC as presentation/application state coordinators, not the place
  for domain business rules.
- Use `BaseViewState<T>` for simple async view state. Use feature-specific
  Freezed state for forms, pagination, upload progress, or realtime screens.
- Do not add `flutter_hooks` by default.
- If a feature needs hooks, use them only for local widget lifecycle concerns:
  controllers, local animation, debounced local input, or small reusable UI
  lifecycle helpers.
- Do not use hooks as a replacement for Cubit/BLoC feature state.
- Use `flutter_native_splash` and `flutter_launcher_icons` only after real brand
  assets are available.
- Treat `package_info_plus`, `formz`, `bloc_concurrency`, `hydrated_bloc`,
  `go_router_builder`, `flutter_gen_runner`, `envied`, `sentry_flutter`, and
  `talker_flutter` as optional feature-driven packages, not boilerplate defaults.
- Add tests near the behavior being changed.

## Memory Workflow

- First check `AGENTS.md` and `docs/agents/memory.md`.
- Add project-wide learnings to `docs/agents/memory.md`.
- Keep personal preferences in local/user memory, not committed docs.
- If instructions become too long, split detail into a new file under
  `docs/agents/` and link it from `AGENTS.md`.

## Research Workflow

- Prefer official docs for tool behavior and package APIs.
- For OpenAI/Codex behavior, use OpenAI docs.
- For Claude Code behavior, use Claude docs.
- For Flutter packages, prefer `pub.dev` package pages and official package docs.
- Note whether information came from local code or external docs.

## Review Checklist

- Does the change preserve Clean Architecture boundaries?
- Are generated inputs regenerated?
- Did analyzer pass?
- Did relevant tests pass?
- Does README or agent memory need an update?
- Did the agent avoid committing secrets or local-only settings?
