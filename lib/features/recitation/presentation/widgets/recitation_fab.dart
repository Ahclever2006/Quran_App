import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class RecitationFab extends StatelessWidget {
  final bool isReady;
  final bool isListening;
  final VoidCallback onStart;
  final VoidCallback onStop;

  const RecitationFab({
    super.key,
    required this.isReady,
    required this.isListening,
    required this.onStart,
    required this.onStop,
  });

  @override
  Widget build(BuildContext context) {
    if (!isReady && !isListening) return const SizedBox.shrink();

    final recitationColors =
        Theme.of(context).extension<RecitationColors>()!;

    final backgroundColor = isListening
        ? recitationColors.fabRecording
        : recitationColors.fabIdle;

    return SizedBox(
      width: 64,
      height: 64,
      child: FloatingActionButton(
        onPressed: isListening ? onStop : onStart,
        backgroundColor: backgroundColor,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        child: Icon(
          isListening ? Icons.stop : Icons.mic,
          size: 32,
        ),
      ),
    );
  }
}
