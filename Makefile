# Flutter Template Makefile
# Provides shortcuts for common development tasks

FVM ?= fvm
FLUTTER := $(FVM) flutter
DART := $(FVM) dart

.PHONY: help fvm-install build-runner clean get test test-unit test-widget test-coverage-html analyze format lint quality quality-check pre-commit setup-hooks watch gen-splash gen-icons gen-branding

# Default target
help: ## Show this help message
	@echo "Flutter Template - Available commands:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

# Dependencies
fvm-install: ## Install/use the pinned Flutter SDK from .fvmrc
	$(FVM) use --skip-pub-get

get: ## Get Flutter dependencies
	$(FLUTTER) pub get

# Code Generation
build-runner: ## Run code generation for all files
	$(DART) run build_runner build

build-runner-watch: ## Run code generation in watch mode
	$(DART) run build_runner watch

clean-build: ## Clean generated files and rebuild
	$(DART) run build_runner clean
	$(DART) run build_runner build

# Specific generators
gen-injectable: ## Generate dependency injection code only
	$(DART) run build_runner build injectable_generator

gen-json: ## Generate JSON serialization code only
	$(DART) run build_runner build json_serializable

gen-retrofit: ## Generate Retrofit API client code only
	$(DART) run build_runner build retrofit_generator

gen-freezed: ## Generate Freezed classes only
	$(DART) run build_runner build freezed

gen-splash: ## Generate native splash screens from tool/branding/flutter_native_splash.yaml
	$(DART) run flutter_native_splash:create --path=tool/branding/flutter_native_splash.yaml

gen-icons: ## Generate launcher icons from tool/branding/flutter_launcher_icons.yaml
	$(DART) run flutter_launcher_icons -f tool/branding/flutter_launcher_icons.yaml

gen-branding: gen-icons gen-splash ## Generate launcher icons and native splash screens

# Code Quality
analyze: ## Run Flutter analyzer
	$(FLUTTER) analyze

format: ## Format Dart code
	$(DART) format lib/ test/ --set-exit-if-changed

format-fix: ## Format and fix Dart code
	$(DART) format lib/ test/ --fix

lint: ## Run all linting checks
	$(FLUTTER) analyze && $(DART) format lib/ test/ --set-exit-if-changed

quality: ## Run full code quality checks (analyze + format + imports)
	@echo "🔍 Running code quality checks..."
	$(DART) run import_sorter:main
	$(DART) format lib/ test/ --fix
	$(FLUTTER) analyze

quality-check: ## Check code quality without fixing
	@echo "🔍 Checking code quality..."
	$(FLUTTER) analyze
	$(DART) format lib/ test/ --set-exit-if-changed

pre-commit: quality-check test ## Run pre-commit checks (quality + tests)
	@echo "✅ Pre-commit checks passed!"

setup-hooks: ## Setup Git pre-commit hooks
	@echo "🔧 Setting up Git hooks..."
	@git config core.hooksPath .githooks
	@chmod +x .githooks/pre-commit
	@echo "✅ Git hooks configured successfully!"
	@echo "💡 Pre-commit hook will now run automatically before each commit"

# Testing
test: ## Run all tests
	$(FLUTTER) test

test-coverage: ## Run tests with coverage
	$(FLUTTER) test --coverage

test-unit: ## Run unit tests only
	$(FLUTTER) test test/core/ test/shared/

test-widget: ## Run widget tests only
	$(FLUTTER) test test/shared/widgets/

test-coverage-html: ## Run tests with coverage and generate HTML report
	@rm -rf coverage/
	$(FLUTTER) test --coverage
	@if command -v genhtml >/dev/null 2>&1; then \
		genhtml coverage/lcov.info -o coverage/html; \
		echo "📄 Coverage report generated at coverage/html/index.html"; \
	else \
		echo "⚠️  Install lcov to generate HTML reports: sudo apt-get install lcov"; \
	fi

# Cleaning
clean: ## Clean build artifacts
	$(FLUTTER) clean
	$(DART) run build_runner clean

clean-all: clean get build-runner ## Clean everything and rebuild

# Import sorting
sort-imports: ## Sort imports using import_sorter
	$(DART) run import_sorter:main

# Development workflow
dev-setup: fvm-install get build-runner sort-imports format analyze ## Complete development setup

# Build commands
build-android: ## Build Android APK
	$(FLUTTER) build apk

build-ios: ## Build iOS
	$(FLUTTER) build ios

build-web: ## Build for web
	$(FLUTTER) build web

# Run commands
run-dev: ## Run development flavor
	$(FLUTTER) run --flavor development --dart-define=FLAVOR=development

run-staging: ## Run staging flavor
	$(FLUTTER) run --flavor staging --dart-define=FLAVOR=staging

run-prod: ## Run production flavor
	$(FLUTTER) run --flavor production --dart-define=FLAVOR=production

run-debug: ## Run app in debug mode
	$(FLUTTER) run --debug

run-release: ## Run app in release mode
	$(FLUTTER) run --release

# Flavor builds
build-dev-debug: ## Build development debug
	$(FLUTTER) build apk --flavor development --debug --dart-define=FLAVOR=development

build-dev-release: ## Build development release
	$(FLUTTER) build apk --flavor development --release --dart-define=FLAVOR=development

build-staging-release: ## Build staging release
	$(FLUTTER) build apk --flavor staging --release --dart-define=FLAVOR=staging

build-prod-release: ## Build production release
	$(FLUTTER) build apk --flavor production --release --dart-define=FLAVOR=production
	$(FLUTTER) build appbundle --flavor production --release --dart-define=FLAVOR=production

build-all-flavors: ## Build all flavors
	$(FLUTTER) build apk --flavor development --release --dart-define=FLAVOR=development
	$(FLUTTER) build apk --flavor staging --release --dart-define=FLAVOR=staging
	$(FLUTTER) build apk --flavor production --release --dart-define=FLAVOR=production
	$(FLUTTER) build appbundle --flavor production --release --dart-define=FLAVOR=production

# Environment setup
setup-development: clean get build-runner run-dev ## Complete development environment setup
