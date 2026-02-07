import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../cubit/recording_timer_cubit.dart';

class RecitationBottomToolbar extends StatelessWidget {
  final bool isListening;
  final int mistakeCount;

  const RecitationBottomToolbar({
    super.key,
    required this.isListening,
    required this.mistakeCount,
  });

  @override
  Widget build(BuildContext context) {
    final recitationColors =
        Theme.of(context).extension<RecitationColors>()!;

    return BottomAppBar(
      child: Row(
        children: [
          if (isListening) ...[
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: recitationColors.recordingIndicator,
              ),
            ),
            const SizedBox(width: 8),
            BlocBuilder<RecordingTimerCubit, Duration>(
              builder: (context, duration) {
                return Text(
                  _formatDuration(duration),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                );
              },
            ),
            const SizedBox(width: 16),
          ],
          if (mistakeCount > 0)
            Chip(
              label: Text(
                '$mistakeCount mistake${mistakeCount == 1 ? '' : 's'}',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
              ),
              backgroundColor:
                  Theme.of(context).colorScheme.errorContainer,
              side: BorderSide.none,
              visualDensity: VisualDensity.compact,
            ),
          const Spacer(),
          const SizedBox(width: 72),
        ],
      ),
    );
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
