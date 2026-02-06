# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Quran Recitation Coach — a Flutter app that listens to a user reciting Quran, tracks word-by-word across an entire surah, detects mistakes via on-device speech recognition, and highlights the correctly read portion incrementally. Fully offline — uses local JSON Mushaf data and the `speech_to_text` package.

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
- **Required packages:** Dartz (functional programming), sizeHelper (responsive sizing), speech_to_text (on-device Arabic speech recognition)
- **Data source:** Local JSON (`lib/assets/qpc-hafs.json`) + static surah metadata (`lib/core/constants/surah_metadata.dart`)
- **Speech:** `speech_to_text` package with `ar` locale, dictation mode, auto-restart on timeout

## Mandatory Coding Rules

- **No hardcoded colors or text sizes in widgets.** All colors, text styles, spacing, and shapes must be defined in `ThemeData`. Widgets consume `Theme.of(context).colorScheme` and `Theme.of(context).textTheme`.
- **Dark mode and light mode required.** Both themes must be supported.
- **RTL text display** for Quranic Arabic content.
- **Android package name:** `com.example.quran_app`
- **Generic UseCase pattern required.** All use cases must extend the base `UseCase<Output, Params>` class in `lib/core/usecases/usecase.dart`. Use `NoParams` for use cases that take no parameters.

## Current State

Clean Architecture with domain/data/presentation layers under `lib/features/recitation/`. Speech services under `lib/features/speech/`. Core utilities (DI, error handling, theming, Arabic text utils, generic UseCase) under `lib/core/`.

Key flows:
- **Surah selection:** Drawer → SurahSelector → RecitationCubit.loadSurah() → loads all ayahs from local JSON
- **Recitation:** FAB → startRecitation() → SpeechRecognitionService listens → RecitationMatchingService compares spoken vs expected words → progress stream updates UI
- **Display:** SurahDisplay widget shows all ayahs in continuous RTL Wrap with WordChips colored by status + AyahNumberMarkers between ayahs
