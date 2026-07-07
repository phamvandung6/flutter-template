# Flutter Template

A Clean Architecture Flutter template with modern development practices.

## Features

- Clean Architecture with domain, data, and presentation layers
- Cubit-first state management with BLoC support and reusable view states
- Dependency injection with GetIt and Injectable
- Type-safe API layer with Dio and Retrofit
- Material Design 3 theme system
- Environment configuration for development, staging, and production
- Freezed, JSON, Retrofit, and Injectable code generation
- Unit and widget test setup
- FVM-pinned Flutter SDK

## Quick Start

```bash
# Install the pinned Flutter SDK, fetch dependencies, generate code, format, and analyze
make dev-setup

# Windows PowerShell
.\scripts\dev-setup.ps1

# Run app
make run-dev
make run-staging
make run-prod
```

## Using This Template

After creating a new repository from this template, rename the boilerplate values
before building your app:

1. Update `name` and `description` in `pubspec.yaml`.
2. Replace Dart imports that start with `package:flutter_template/` if you change
   the package name.
3. Replace Android identifiers in `android/app/build.gradle` and
   `android/app/src/main/kotlin/com/example/flutter_template/`.
4. Replace iOS bundle identifiers and display names in `ios/Runner/Info.plist`
   and the Xcode project settings.
5. Update app names, bundle IDs, database names, and API base URLs in
   `lib/core/config/environments/`.
6. Run `fvm flutter pub get` and `fvm dart run build_runner build`.

Generated files are intentionally ignored. Run code generation after cloning or
after changing Freezed, JSON, Retrofit, or Injectable inputs.

## Project Structure

```text
lib/
|-- core/                 # Core functionality
|   |-- bloc/             # Global BLoC observers
|   |-- config/           # App configuration and environments
|   |-- di/               # Dependency injection
|   |-- domain/           # Shared domain primitives and use case base classes
|   |-- error/            # Error handling
|   |-- navigation/       # Routing and navigation
|   |-- network/          # HTTP client and API
|   `-- utils/            # Utilities and helpers
|-- features/             # Feature modules
|   |-- auth/             # Authentication
|   |-- home/             # Home screen
|   |-- splash/           # Splash screen
|   `-- error/            # Error pages
|-- shared/               # Shared components
|   |-- presentation/     # Base BLoC/Cubit classes
|   |-- theme/            # Theme system
|   |-- utils/            # Shared utilities
|   `-- widgets/          # Reusable UI components
`-- main.dart             # App entry point
```

## Agent Context

This repository includes shared agent instructions:

- `AGENTS.md`: primary instructions for Codex and agentic coding tools.
- `CLAUDE.md`: Claude Code entry point; imports `AGENTS.md`.
- `docs/agents/`: architecture, memory, skills, and agent handbook.

## Toolchain

This project is pinned to Flutter `3.44.5` via FVM. Makefile commands run
through `fvm flutter` and `fvm dart`, so install FVM before using them.

```bash
fvm flutter --version
```

## Available Commands

```bash
make help              # Show all available commands

# Setup
make fvm-install       # Install/use pinned Flutter SDK
make dev-setup         # Full setup: FVM, pub get, codegen, format, analyze
make setup-hooks       # Configure Git hooks

# Development
make get               # Get dependencies
make build-runner      # Generate code
make gen-icons         # Generate launcher icons after adding brand assets
make gen-splash        # Generate native splash after adding brand assets
make sort-imports      # Sort imports
make format            # Check formatting
make quality           # Format, sort imports, analyze
make quality-check     # Analyze and check formatting
make clean             # Clean build artifacts

# Testing
make test              # Run all tests
make test-unit         # Run unit tests only
make test-widget       # Run widget tests only
make test-coverage     # Run tests with coverage

# Running
make run-dev           # Run development flavor
make run-staging       # Run staging flavor
make run-prod          # Run production flavor

# Building
make build-android     # Build Android APK
make build-ios         # Build iOS
make build-web         # Build web
```

Windows PowerShell alternatives:

```powershell
.\scripts\dev-setup.ps1
.\scripts\quality-check.ps1
.\scripts\test.ps1
```

## Architecture

### Clean Architecture Layers

- Presentation: Cubit/BLoC, pages, and widgets
- Domain: entities, use cases, and repository interfaces
- Data: models, data sources, and repository implementations

### State Management

The template uses `flutter_bloc` with a Cubit-first guideline:

- Use `Cubit` for simple screen/app UI state such as theme, filters, toggles,
  and one-shot loads.
- Use `Bloc` when the flow is event-driven, needs traceability, or needs event
  handling such as debounce, retry, queueing, or cancellation.
- Keep domain business rules in use cases. Cubit/BLoC should coordinate
  presentation state, call use cases, and map results into view state.
- `BaseViewState<T>` is the shared async view state for both Cubit and BLoC.
  For complex forms, pagination, upload progress, or realtime screens, prefer a
  feature-specific Freezed state instead of forcing everything into the base
  state.

Simple state should start with `BaseCubit<T>`:

```dart
class UserCubit extends BaseCubit<User> {
  UserCubit(this._getUserUseCase, AppLogger logger)
      : super(const BaseViewState<User>(), logger);

  final GetUserUseCase _getUserUseCase;

  Future<void> loadUser() {
    return handleEitherResult(_getUserUseCase(const NoParams()));
  }
}
```

Use `BaseBloc<Event, T>` when events make the flow clearer:

```dart
sealed class UserEvent extends BaseBlocEvent {
  const UserEvent();
}

final class UserRequested extends UserEvent {
  const UserRequested();
}

class UserBloc extends BaseBloc<UserEvent, User> {
  UserBloc(this._getUserUseCase, AppLogger logger)
      : super(const BaseViewState<User>(), logger) {
    on<UserRequested>(_onUserRequested);
  }

  final GetUserUseCase _getUserUseCase;

  Future<void> _onUserRequested(
    UserRequested event,
    Emitter<BaseViewState<User>> emit,
  ) {
    return handleEitherResult(emit, _getUserUseCase(const NoParams()));
  }
}
```

### Optional Flutter Hooks

`flutter_hooks` is not included by default. Add it only when a real feature needs
reusable local widget lifecycle logic.

Good fits for hooks:

- Text, focus, scroll, page, tab, and animation controllers local to a widget.
- Small local UI state that does not belong in Cubit/BLoC.
- Reusable UI lifecycle helpers such as debounced text input or fade-in
  animation hooks.

Avoid hooks for:

- Domain business rules.
- Auth/session state.
- API loading state for a screen.
- Pagination, upload, sync, checkout, or other multi-step flows.
- State that should be tested independently from widgets.

If hooks are added later, keep them presentation-only and prefer names starting
with `use...`.

### Key Dependencies

- `flutter_bloc`: state management
- `get_it` and `injectable`: dependency injection
- `dio` and `retrofit`: HTTP client and API generation
- `freezed` and `json_serializable`: immutable models and JSON
- `go_router`: navigation
- `dartz`: functional result types
- `very_good_analysis`: linting baseline
- `flutter_native_splash`: native splash generation
- `flutter_launcher_icons`: launcher icon generation

Optional, add only when needed:

- `flutter_hooks`: reusable local widget lifecycle helpers
- `package_info_plus`: app version/build metadata for settings, diagnostics, or
  support screens
- `formz`: Cubit/BLoC-friendly form validation for real forms
- `bloc_concurrency`: event transformers for search, submit, upload, or sync
  flows
- `hydrated_bloc`: non-sensitive Cubit/BLoC state persistence
- `go_router_builder`: typed routes when navigation params grow
- `flutter_gen_runner`: typed asset/font access when asset usage grows
- `envied`: generated build-time environment constants when runtime config is
  not enough
- `sentry_flutter`: production crash/error reporting when a Sentry project is
  configured
- `talker_flutter` and related Talker integrations: richer debug logging when
  the built-in logger is not enough

## Environment Setup

Each environment has configuration in `lib/core/config/environments/`.

```bash
make run-dev
make run-staging
make run-prod
```

## Code Generation

Run code generation after editing Freezed models, JSON DTOs, Retrofit clients,
or Injectable registrations.

```bash
make build-runner
```

Generated files are ignored by git, so a fresh clone should run `make dev-setup`.

## Branding Generation

Branding generators are included as dev tools, but real brand assets are not
included in the boilerplate. Before generating icons or splash screens:

1. Add project assets such as `assets/branding/app_icon.png` and
   `assets/branding/splash_logo.png`.
2. Copy the example configs from `tool/branding/*.example` to matching `.yaml`
   files.
3. Adjust colors and paths.
4. Run:

```bash
make gen-icons
make gen-splash
```

## Testing

```bash
make test
make test-unit
make test-widget
make test-coverage
```

## Code Quality

```bash
make quality
make quality-check
make pre-commit
```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for development guidelines.

## License

MIT License - see [LICENSE](LICENSE) for details.
