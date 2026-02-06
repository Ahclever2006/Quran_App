import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/recitation_progress.dart';

class WordChip extends StatelessWidget {
  final String word;
  final WordStatus status;
  final bool isRevealed;

  const WordChip({
    super.key,
    required this.word,
    required this.status,
    this.isRevealed = true,
  });

  @override
  Widget build(BuildContext context) {
    final recitationColors = Theme.of(context).extension<RecitationColors>()!;
    final color =
        isRevealed ? _colorForStatus(recitationColors) : Colors.transparent;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Text(
        word,
        style: Theme.of(context).textTheme.headlineSmall!.copyWith(
              color: color,
            ),
      ),
    );
  }

  Color _colorForStatus(RecitationColors colors) {
    switch (status) {
      case WordStatus.confirmed:
        return colors.confirmed;
      case WordStatus.cursor:
        return colors.cursor;
      case WordStatus.mistake:
        return colors.mistake;
      case WordStatus.pending:
        return colors.pending;
    }
  }
}
