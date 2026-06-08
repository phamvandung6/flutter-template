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
| UI polish or widgets | Frontend/a11y plus Flutter patterns |

## Flutter Implementation Rules

- Prefer existing project patterns before introducing a new abstraction.
- Keep domain pure: no Flutter, Dio, storage, or Retrofit imports.
- Keep data-layer DTOs and API clients under `features/*/data`.
- Use use cases as the boundary between BLoC and repositories.
- Use `Either<Failure, T>` for recoverable domain/data results.
- Use `BaseBlocState<T>` and existing state factories for presentation state.
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
