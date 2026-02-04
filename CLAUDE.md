# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Quran Recitation Coach — a Flutter app that listens to a user reciting Quran, tracks the selected ayah word-by-word, detects mistakes (mock in MVP), and highlights the correctly read portion incrementally. The backend is a Python FastAPI server communicating via WebSocket.

Full requirements are in `specs/initial_requirements.md`.

## Build & Run Commands

```bash
# Flutter SDK is at ~/Desktop/flutterSDK3.35.2/flutter (see .vscode/settings.json)
flutter run                    # Run on connected device/emulator
flutter build apk              # Build Android APK
flutter build ios              # Build iOS
flutter test                   # Run all tests
flutter test test/widget_test.dart  # Run a single test file
flutter analyze                # Run static analysis (lints from flutter_lints)
flutter pub get                # Install dependencies
```

## Tech Stack & Architecture

- **SDK:** Dart ^3.9.0, Flutter 3.35.2
- **Target architecture:** Clean Architecture + BLoC/Cubit
- **Required packages (per spec):** Dio (HTTP), Dartz (functional programming), sizeHelper (responsive sizing)
- **External API:** AlQuran Cloud (`https://api.alquran.cloud/api`) — free, no auth required
- **Backend:** Python FastAPI with WebSocket for streaming audio and receiving alignment events

## Mandatory Coding Rules

- **No hardcoded colors or text sizes in widgets.** All colors, text styles, spacing, and shapes must be defined in `ThemeData`. Widgets consume `Theme.of(context).colorScheme` and `Theme.of(context).textTheme`.
- **Dark mode and light mode required.** Both themes must be supported.
- **RTL text display** for Quranic Arabic content.
- **Android package name:** `com.example.quran_app`
- **Generic UseCase pattern required.** All use cases must extend the base `UseCase<Output, Params>` class in `lib/core/usecases/usecase.dart`. Use `NoParams` for use cases that take no parameters.

## Current State

Clean Architecture is implemented with domain/data/presentation layers under `lib/features/recitation/`. Core utilities (DI, error handling, theming, networking, generic UseCase) live under `lib/core/`.
