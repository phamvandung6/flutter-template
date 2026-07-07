---
paths:
  - "test/**/*.dart"
---

# Testing Rules

- Use `bloc_test` for BLoC/Cubit behavior.
- Use `mocktail` for mocks and fakes.
- Keep smoke tests initializing `AppConfig` and `configureDependencies()`.
- Await async cleanup, including `cubit.close()`.
- Run `fvm flutter test` before final handoff after test changes.
