# Flutter Template

A Clean Architecture Flutter template with modern development practices.

## Features

- **Clean Architecture** (Domain/Data/Presentation)
- **BLoC State Management** with base classes
- **Dependency Injection** (GetIt + Injectable)
- **Type-safe API** (Dio + Retrofit)
- **Material Design 3** theme system
- **Environment Configuration** (Dev/Staging/Prod)
- **Code Generation** setup
- **Comprehensive Testing** framework

## Quick Start

```bash
# Setup
flutter pub get
make dev-setup

# Run app
make run-dev        # Development
make run-staging    # Staging  
make run-prod       # Production
```

## Project Structure

```
lib/
├── core/                 # Core functionality
│   ├── bloc/            # Global BLoC observers
│   ├── config/          # App configuration & environments
│   ├── di/              # Dependency injection
│   ├── error/           # Error handling
│   ├── navigation/      # Routing & navigation
│   ├── network/         # HTTP client & API
│   └── utils/           # Utilities & helpers
├── features/            # Feature modules
│   ├── auth/           # Authentication
│   ├── home/           # Home screen
│   ├── splash/         # Splash screen
│   └── error/          # Error pages
├── shared/             # Shared components
│   ├── presentation/   # Base BLoC/Cubit classes
│   ├── theme/          # Theme system
│   ├── utils/          # Shared utilities
│   └── widgets/        # Reusable UI components
└── main.dart           # App entry point
```

## Available Commands

```bash
make help              # Show all available commands

# Development
make get               # Get dependencies
make build-runner      # Generate code
make quality           # Format, sort imports, analyze
make test              # Run all tests
make clean             # Clean build artifacts

# Running
make run-dev           # Run development
make run-staging       # Run staging
make run-prod          # Run production

# Building
make build-android     # Build Android APK
make build-ios         # Build iOS
make build-web         # Build web
```

## Architecture

### Clean Architecture Layers

- **Presentation**: BLoC/Pages/Widgets
- **Domain**: Entities/Use Cases/Repository Interfaces  
- **Data**: Models/Data Sources/Repository Implementations

### State Management

Using BLoC pattern with single state architecture:

```dart
class UserBloc extends BaseBloc<User> {
  UserBloc(this._getUserUseCase) : super(BaseBlocState.initial());
  
  Future<void> loadUser() async {
    await handleEitherResult(
      _getUserUseCase(NoParams()),
      onSuccess: (user) => emitSuccess(user),
    );
  }
}
```

### Key Dependencies

- `flutter_bloc`: State management
- `get_it` + `injectable`: Dependency injection
- `dio` + `retrofit`: HTTP client
- `go_router`: Navigation
- `dartz`: Functional programming
- `very_good_analysis`: Linting

## Environment Setup

### Development
```bash
make run-dev
```

### Staging  
```bash
make run-staging
```

### Production
```bash
make run-prod
```

Each environment has its own configuration in `lib/core/config/environments/`.

## Testing

```bash
make test              # All tests
make test-unit         # Unit tests only
make test-widget       # Widget tests only
make test-coverage     # With coverage report
```

## Code Quality

```bash
make quality           # Fix formatting, imports, analyze
make quality-check     # Check only (for CI)
make pre-commit        # Full pre-commit checks
```

## Contributing

1. Fork the repository
2. Create feature branch: `git checkout -b feature/new-feature`
3. Make changes and add tests
4. Run quality checks: `make pre-commit`
5. Submit pull request

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines.

## License

MIT License - see [LICENSE](LICENSE) file for details.