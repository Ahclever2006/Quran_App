import 'package:flutter/material.dart';

class RecitationControls extends StatelessWidget {
  final bool isListening;
  final bool isReady;
  final VoidCallback onStart;
  final VoidCallback onStop;
  final VoidCallback onReset;

  const RecitationControls({
    super.key,
    required this.isListening,
    required this.isReady,
    required this.onStart,
    required this.onStop,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (!isListening)
          FilledButton.icon(
            onPressed: isReady ? onStart : null,
            icon: const Icon(Icons.mic),
            label: const Text('Start'),
          )
        else
          FilledButton.icon(
            onPressed: onStop,
            icon: const Icon(Icons.stop),
            label: const Text('Stop'),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
          ),
        const SizedBox(width: 16),
        OutlinedButton.icon(
          onPressed: onReset,
          icon: const Icon(Icons.refresh),
          label: const Text('Reset'),
        ),
      ],
    );
  }
}
