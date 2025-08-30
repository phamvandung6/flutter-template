# Flutter Template Makefile
# Provides shortcuts for common development tasks

.PHONY: help build-runner clean get test analyze format lint watch

# Default target
help: ## Show this help message
	@echo "Flutter Template - Available commands:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

# Dependencies
get: ## Get Flutter dependencies
	flutter pub get

# Code Generation
build-runner: ## Run code generation for all files
	dart run build_runner build --delete-conflicting-outputs

build-runner-watch: ## Run code generation in watch mode
	dart run build_runner watch --delete-conflicting-outputs

clean-build: ## Clean generated files and rebuild
	dart run build_runner clean
	dart run build_runner build --delete-conflicting-outputs

# Specific generators
gen-injectable: ## Generate dependency injection code only
	dart run build_runner build --delete-conflicting-outputs injectable_generator

gen-json: ## Generate JSON serialization code only
	dart run build_runner build --delete-conflicting-outputs json_serializable

gen-retrofit: ## Generate Retrofit API client code only
	dart run build_runner build --delete-conflicting-outputs retrofit_generator

gen-freezed: ## Generate Freezed classes only
	dart run build_runner build --delete-conflicting-outputs freezed

# Code Quality
analyze: ## Run Flutter analyzer
	flutter analyze

format: ## Format Dart code
	dart format lib/ test/ --set-exit-if-changed

format-fix: ## Format and fix Dart code
	dart format lib/ test/ --fix

lint: ## Run all linting checks
	flutter analyze && dart format lib/ test/ --set-exit-if-changed

# Testing
test: ## Run all tests
	flutter test

test-coverage: ## Run tests with coverage
	flutter test --coverage

# Cleaning
clean: ## Clean build artifacts
	flutter clean
	dart run build_runner clean

clean-all: clean get build-runner ## Clean everything and rebuild

# Import sorting
sort-imports: ## Sort imports using import_sorter
	dart run import_sorter:main

# Development workflow
dev-setup: get build-runner sort-imports format analyze ## Complete development setup

# Build commands
build-android: ## Build Android APK
	flutter build apk

build-ios: ## Build iOS
	flutter build ios

build-web: ## Build for web
	flutter build web

# Run commands
run-dev: ## Run development flavor
	flutter run --flavor development --dart-define=FLAVOR=development

run-staging: ## Run staging flavor
	flutter run --flavor staging --dart-define=FLAVOR=staging

run-prod: ## Run production flavor
	flutter run --flavor production --dart-define=FLAVOR=production

run-debug: ## Run app in debug mode
	flutter run --debug

run-release: ## Run app in release mode
	flutter run --release

# Flavor builds
build-dev-debug: ## Build development debug
	flutter build apk --flavor development --debug --dart-define=FLAVOR=development

build-dev-release: ## Build development release
	flutter build apk --flavor development --release --dart-define=FLAVOR=development

build-staging-release: ## Build staging release
	flutter build apk --flavor staging --release --dart-define=FLAVOR=staging

build-prod-release: ## Build production release
	flutter build apk --flavor production --release --dart-define=FLAVOR=production
	flutter build appbundle --flavor production --release --dart-define=FLAVOR=production

build-all-flavors: ## Build all flavors
	flutter build apk --flavor development --release --dart-define=FLAVOR=development
	flutter build apk --flavor staging --release --dart-define=FLAVOR=staging
	flutter build apk --flavor production --release --dart-define=FLAVOR=production
	flutter build appbundle --flavor production --release --dart-define=FLAVOR=production

# Environment setup
setup-development: clean get build-runner run-dev ## Complete development environment setup
