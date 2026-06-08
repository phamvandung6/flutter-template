# Architecture Map

## Stack

| Concern | Choice |
| --- | --- |
| SDK | Flutter 3.44.1 via FVM |
| Language | Dart 3.12.1 |
| State | flutter_bloc, Cubit-first with BLoC for event-driven flows |
| Local widget lifecycle | StatefulWidget by default; flutter_hooks optional when needed |
| DI | get_it, injectable |
| Navigation | go_router |
| HTTP | dio, retrofit |
| Models | freezed, json_serializable |
| Functional results | dartz Either |
| Storage | flutter_secure_storage |
| Branding tools | flutter_native_splash, flutter_launcher_icons |
| Lints | very_good_analysis plus local relaxations |
| Tests | flutter_test, bloc_test, mocktail |

## Layering

```text
lib/
|-- core/                 # App-wide infrastructure
|   |-- bloc/             # Global BLoC observer
|   |-- config/           # Environment configuration
|   |-- di/               # Injectable/GetIt setup
|   |-- error/            # Exceptions and failures
|   |-- navigation/       # GoRouter, guards, observers, navigation service
|   |-- network/          # Dio client, API responses, interceptors
|   `-- utils/            # Logger, typedefs, use case base classes
|-- features/
|   |-- auth/             # Clean Architecture auth module
|   |-- error/            # Error and not found pages
|   |-- home/             # Home page
|   `-- splash/           # Splash page
`-- shared/               # Theme, base presentation primitives, reusable widgets
```

## App Startup

1. `main()` calls `WidgetsFlutterBinding.ensureInitialized()`.
2. `AppConfig.initialize()` chooses the current environment.
3. `configureDependencies()` registers Injectable/GetIt dependencies.
4. `Bloc.observer` is set from DI.
5. `MyApp` provides global `AuthBloc` and `ThemeCubit`.
6. `MaterialApp.router` uses `AppRouter.createRouter(context)`.

## Auth Flow

```text
UI event
-> AuthBloc
-> use case in features/auth/domain/usecases/
-> AuthRepository interface
-> AuthRepositoryImpl
-> NetworkInfo guard
-> AuthRemoteDataSource / AuthLocalDataSource
-> DTO <-> Entity mapping
-> Either<Failure, UserEntity>
-> BaseViewState<Auth data>
```

## State Management Policy

- Use `Cubit` by default for simple screen or app state.
- Use `Bloc` when the feature benefits from explicit events, traceability, event
  transformers, or multiple action sources.
- Keep business rules in domain use cases. Cubit/BLoC coordinates presentation
  state and maps use case results into view state.
- `BaseViewState<T>` is a convenience for simple async view state. Complex
  screens should define their own Freezed state.
- Do not wire one Bloc/Cubit directly into another. Share data through use cases,
  repositories, streams, or UI-level listeners.

## Flutter Hooks Policy

- Do not include `flutter_hooks` in the boilerplate by default.
- Add `flutter_hooks` only when a feature has repeated local widget lifecycle
  logic that is cleaner as a hook.
- Good hook use cases: text/focus/scroll/tab/page/animation controllers,
  debounced local input, small reusable UI lifecycle helpers.
- Hooks must stay in the presentation layer and use `use...` naming.
- Do not use hooks for domain rules, API screen state, auth/session state,
  pagination, upload, checkout, sync, or other feature workflows.

## Optional Package Catalog

Do not add these packages by default. Add them only when the feature need is
concrete and the architecture impact is understood.

| Package | Add when |
| --- | --- |
| package_info_plus | Settings, diagnostics, or support UI needs app version/build metadata. |
| formz | Real forms need typed validation with Cubit/BLoC. |
| bloc_concurrency | Bloc events need debounce, droppable, restartable, or sequential handling. |
| hydrated_bloc | Non-sensitive Cubit/BLoC state should persist across app restarts. |
| go_router_builder | Routes and path/query params become hard to maintain as strings. |
| flutter_gen_runner | Asset/font usage grows enough that string paths become risky. |
| envied | Build-time environment constants are needed and secret handling is reviewed. |
| sentry_flutter | Production crash/error reporting is configured for the app. |
| talker_flutter | Debug logging needs an in-app console or richer Dio/BLoC integrations. |

## Routing

- `AppRouter` owns route registration.
- `AuthGuard.checkAccess` owns redirect decisions.
- `NavigationService.navigatorKey` supports context-light navigation helpers.
- Several routes intentionally use placeholder pages until real feature screens
  are implemented.

## Code Generation Boundaries

Generator inputs:

- Freezed classes in DTOs, entities, and base states.
- `@RestApi` / Retrofit API interfaces.
- `@injectable`, `@lazySingleton`, and `@module` registrations.

Do not edit generated files directly. Regenerate with:

```bash
fvm dart run build_runner build
```

## Branding Generation

- `flutter_native_splash` and `flutter_launcher_icons` are dev tools for app
  branding.
- The boilerplate keeps only example configs in `tool/branding/`.
- Do not run branding generators until real project assets exist.
- Copy `tool/branding/*.example` to `.yaml`, adjust asset paths/colors, then run
  `make gen-icons` and `make gen-splash`.

## Current Known Placeholders

- `AuthRepositoryImpl.isAuthenticated` returns a placeholder value.
- `AuthRepositoryImpl.currentUser` is a placeholder synchronous getter.
- Login/register/profile/settings routes have placeholder pages.
- Real token refresh API call in `AuthInterceptor` is marked TODO.
