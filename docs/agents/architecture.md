# Architecture Map

## Stack

| Concern | Choice |
| --- | --- |
| SDK | Flutter 3.44.1 via FVM |
| Language | Dart 3.12.1 |
| State | flutter_bloc, Cubit/BLoC |
| DI | get_it, injectable |
| Navigation | go_router |
| HTTP | dio, retrofit |
| Models | freezed, json_serializable |
| Functional results | dartz Either |
| Storage | flutter_secure_storage |
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
-> BaseBlocState<Auth data>
```

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

## Current Known Placeholders

- `AuthRepositoryImpl.isAuthenticated` returns a placeholder value.
- `AuthRepositoryImpl.currentUser` is a placeholder synchronous getter.
- Login/register/profile/settings routes have placeholder pages.
- Real token refresh API call in `AuthInterceptor` is marked TODO.
