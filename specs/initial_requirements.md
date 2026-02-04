# Project: Quran Recitation Coach (Flutter + Backend MVP)
**Stack:** Flutter (Clean Architecture + BLoC/Cubit) + Python FastAPI backend (WebSocket)  
**Quran Text API:** AlQuran Cloud (free, no auth) — https://api.alquran.cloud/api  

---

## Goal
Build a Flutter app that listens to a user reciting Quran, tracks the selected ayah word-by-word, detects mistakes (mock in MVP), and highlights the correctly read portion incrementally (part-by-part). Similar interaction to Tarteel.

---

## MVP Scope (Must-Have)
1. User selects:
   - Surah number (1..114)
   - Ayah number
2. App fetches ayah text from **AlQuran Cloud API**.
3. App displays ayah text tokenized into words (RTL).
4. App records microphone audio and streams it to backend via WebSocket.
5. Backend returns incremental progress events (mock alignment in MVP):
   - cursorIndex
   - confirmedIndex
   - optional mistakeIndex + mistakeType
6. Flutter highlights words:
   - words <= confirmedIndex as “correct”
   - cursor word as “in progress”
   - mistake word in red
7. Controls:
   - Start / Stop listening
   - Reset session

---

## Non-Goals (Not in MVP)
- Real Quran ASR / forced alignment
- Tajweed rule validation
- Auto-detect start position anywhere in Quran
- Offline inference

---

# ❗ Additional Mandatory Requirements (IMPORTANT)

## 1) Theming (Dark Mode and Light Mode)

### Global Rules
- The app **must support dark mode and Light Mode**
- **No hardcoded colors or text sizes inside widgets**
- **use Dio package and Dartz package and sizeHelper package**

### Implementation Rules
- Define **all colors, text styles, spacing, and shapes** in:
  - `ThemeData` inside `MaterialApp`
- Widgets must consume:
  - `Theme.of(context).colorScheme`
  - `Theme.of(context).textTheme`

### Example (Guideline Only)
```dart
MaterialApp(
  theme: ThemeData.dark().copyWith(
    colorScheme: const ColorScheme.dark(
      primary: Colors.green,
      secondary: Colors.teal,
      error: Colors.redAccent,
    ),
  ),
);
