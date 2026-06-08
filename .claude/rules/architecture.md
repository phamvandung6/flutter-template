---
paths:
  - "lib/core/**"
  - "lib/features/**"
  - "lib/shared/**"
---

# Architecture Rules

- Keep domain code independent of Flutter, Dio, Retrofit, storage, and UI.
- Keep data sources and DTOs in the data layer.
- Keep BLoC/Cubit and widgets in the presentation layer.
- Prefer Cubit for simple state; use Bloc for event-driven flows that need
  traceability or event transformers.
- Keep domain business rules in use cases, not in Cubit/BLoC.
- Add new dependencies through DI when they cross feature or infrastructure
  boundaries.
- Use explicit DTO/entity mapping at data/domain boundaries.
- Return `Either<Failure, T>` through repository and use case boundaries.
