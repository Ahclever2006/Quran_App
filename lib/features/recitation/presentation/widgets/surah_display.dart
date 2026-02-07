import 'package:flutter/material.dart';
import '../../domain/entities/ayah.dart';
import '../../domain/entities/recitation_progress.dart';
import 'ayah_number_marker.dart';
import 'word_chip.dart';

class SurahDisplay extends StatelessWidget {
  final List<Ayah> ayahs;
  final RecitationProgress? progress;
  final bool showHelpWords;
  final bool showAllText;

  const SurahDisplay({
    super.key,
    required this.ayahs,
    this.progress,
    this.showHelpWords = false,
    this.showAllText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: RepaintBoundary(
          child: Wrap(
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 4,
            runSpacing: 8,
            children: _buildChildren(),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildChildren() {
    final children = <Widget>[];
    for (var ayahIdx = 0; ayahIdx < ayahs.length; ayahIdx++) {
      final ayah = ayahs[ayahIdx];
      final wordStatuses = progress?.ayahWordStatuses[ayahIdx];
      for (var wordIdx = 0;
          wordIdx < ayah.recitationWords.length;
          wordIdx++) {
        children.add(WordChip(
          word: ayah.recitationWords[wordIdx],
          status: _statusAt(wordStatuses, wordIdx),
          isRevealed: _isRevealed(wordStatuses, wordIdx),
          showAllText: showAllText,
        ));
      }
      children.add(AyahNumberMarker(ayahNumber: ayah.numberInSurah));
    }
    return children;
  }

  WordStatus _statusAt(List<WordStatus>? wordStatuses, int wordIdx) {
    if (wordStatuses == null || wordIdx >= wordStatuses.length) {
      return WordStatus.pending;
    }
    return wordStatuses[wordIdx];
  }

  bool _isRevealed(List<WordStatus>? wordStatuses, int wordIdx) {
    final status = _statusAt(wordStatuses, wordIdx);
    return status == WordStatus.confirmed ||
        status == WordStatus.mistake ||
        (showHelpWords && status == WordStatus.cursor);
  }
}
