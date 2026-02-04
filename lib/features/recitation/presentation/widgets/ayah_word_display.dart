import 'package:flutter/material.dart';
import '../../domain/entities/ayah.dart';
import '../../domain/entities/recitation_progress.dart';
import 'ayah_number_marker.dart';
import 'word_chip.dart';

class AyahWordDisplay extends StatelessWidget {
  final Ayah ayah;
  final RecitationProgress? progress;

  const AyahWordDisplay({
    super.key,
    required this.ayah,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Wrap(
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 4,
        runSpacing: 8,
        children: [
          ...List.generate(ayah.words.length, (index) {
            final status = progress != null
                ? progress!.wordStatuses[index]
                : WordStatus.pending;
            final isRevealed =
                progress != null && status != WordStatus.pending;
            return WordChip(
              word: ayah.words[index],
              status: status,
              isRevealed: isRevealed,
            );
          }),
          AyahNumberMarker(ayahNumber: ayah.numberInSurah),
        ],
      ),
    );
  }
}
