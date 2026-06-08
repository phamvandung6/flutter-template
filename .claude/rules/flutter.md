---
paths:
  - "lib/**/*.dart"
  - "test/**/*.dart"
---

# Flutter And Dart Rules

- Use the pinned SDK through FVM.
- Follow existing Clean Architecture boundaries.
- Prefer `const` constructors and extracted widgets.
- Avoid `!` unless the invariant is obvious and local.
- Check `mounted` after `await` before using `BuildContext`.
- Use `unawaited(...)` for intentional fire-and-forget futures.
- Use `withValues(alpha: ...)` instead of deprecated `withOpacity(...)`.
- Run `fvm flutter analyze` after behavior or API changes.
