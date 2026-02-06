import 'dart:async';
import 'dart:math';
import '../../core/utils/arabic_text_utils.dart';
import '../recitation/domain/entities/ayah.dart';
import '../recitation/domain/entities/recitation_progress.dart';

class RecitationMatchingService {
  List<Ayah> _ayahs = [];
  // Flattened list of expected words across all ayahs
  List<_ExpectedWord> _expectedWords = [];
  // Locked-in statuses for words already evaluated. Once a word is locked
  // it keeps its status regardless of future partial-result revisions.
  List<WordStatus> _lockedStatuses = [];

  final _progressController =
      StreamController<RecitationProgress>.broadcast();

  Stream<RecitationProgress> get progressStream => _progressController.stream;

  void initialize(List<Ayah> ayahs) {
    _ayahs = ayahs;
    _lockedStatuses = [];
    _expectedWords = [];
    for (var i = 0; i < ayahs.length; i++) {
      for (var j = 0; j < ayahs[i].recitationWords.length; j++) {
        _expectedWords.add(_ExpectedWord(
          ayahIndex: i,
          wordIndex: j,
          text: ayahs[i].recitationWords[j],
        ));
      }
    }
    _emitProgress();
  }

  void processRecognizedText(String fullText) {
    final spokenWords =
        fullText.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    if (spokenWords.isEmpty) return;

    final lockedCount = _lockedStatuses.length;

    // Lock all spoken words except the last one — the last word in a
    // partial result is still being refined by the recognizer.
    final lockUpTo = min(spokenWords.length - 1, _expectedWords.length);

    for (var i = lockedCount; i < lockUpTo; i++) {
      final matches =
          ArabicTextUtils.wordsMatch(spokenWords[i], _expectedWords[i].text);
      _lockedStatuses.add(
          matches ? WordStatus.confirmed : WordStatus.mistake);
    }

    _emitProgressFromSpoken(spokenWords);
  }

  void _emitProgressFromSpoken(List<String> spokenWords) {
    final statuses = <int, List<WordStatus>>{};
    for (var i = 0; i < _ayahs.length; i++) {
      statuses[i] = List.filled(
          _ayahs[i].recitationWords.length, WordStatus.pending);
    }

    final lockedCount = _lockedStatuses.length;
    final totalSpoken = spokenWords.length;

    for (var i = 0; i < _expectedWords.length; i++) {
      final ew = _expectedWords[i];
      if (i < lockedCount) {
        // Use the locked status — already evaluated and stable
        statuses[ew.ayahIndex]![ew.wordIndex] = _lockedStatuses[i];
      } else if (i < totalSpoken) {
        // Trailing (unlocked) spoken word — evaluate live but don't persist
        final matches =
            ArabicTextUtils.wordsMatch(spokenWords[i], ew.text);
        statuses[ew.ayahIndex]![ew.wordIndex] =
            matches ? WordStatus.confirmed : WordStatus.cursor;
      } else if (i == totalSpoken) {
        statuses[ew.ayahIndex]![ew.wordIndex] = WordStatus.cursor;
      }
    }

    // Find current ayah/word indices
    int currentAyahIndex = 0;
    int currentWordIndex = 0;
    if (totalSpoken < _expectedWords.length) {
      final cursorWord = _expectedWords[totalSpoken];
      currentAyahIndex = cursorWord.ayahIndex;
      currentWordIndex = cursorWord.wordIndex;
    } else if (_expectedWords.isNotEmpty) {
      final lastWord = _expectedWords.last;
      currentAyahIndex = lastWord.ayahIndex;
      currentWordIndex = lastWord.wordIndex;
    }

    _progressController.add(RecitationProgress(
      currentAyahIndex: currentAyahIndex,
      currentWordIndex: currentWordIndex,
      ayahWordStatuses: statuses,
    ));
  }

  void _emitProgress() {
    final statuses = <int, List<WordStatus>>{};
    for (var i = 0; i < _ayahs.length; i++) {
      statuses[i] = List.filled(
          _ayahs[i].recitationWords.length, WordStatus.pending);
    }
    if (_expectedWords.isNotEmpty) {
      statuses[0]![0] = WordStatus.cursor;
    }
    _progressController.add(RecitationProgress(
      currentAyahIndex: 0,
      currentWordIndex: 0,
      ayahWordStatuses: statuses,
    ));
  }

  void reset() {
    _lockedStatuses = [];
    if (_ayahs.isNotEmpty) {
      _emitProgress();
    }
  }

  void dispose() {
    _progressController.close();
  }
}

class _ExpectedWord {
  final int ayahIndex;
  final int wordIndex;
  final String text;

  const _ExpectedWord({
    required this.ayahIndex,
    required this.wordIndex,
    required this.text,
  });
}
