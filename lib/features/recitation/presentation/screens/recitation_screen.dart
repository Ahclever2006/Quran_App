import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/recitation_progress.dart';
import '../../../settings/presentation/cubit/settings_cubit.dart';
import '../cubit/recitation_cubit.dart';
import '../cubit/recitation_state.dart';
import '../cubit/recording_timer_cubit.dart';
import '../widgets/recitation_bottom_toolbar.dart';
import '../widgets/recitation_drawer.dart';
import '../widgets/recitation_fab.dart';
import '../widgets/surah_display.dart';

class RecitationScreen extends StatefulWidget {
  const RecitationScreen({super.key});

  @override
  State<RecitationScreen> createState() => _RecitationScreenState();
}

class _RecitationScreenState extends State<RecitationScreen> {
  bool _showAllText = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<RecitationCubit, RecitationState>(
      listener: (context, state) {
        if (state is RecitationListening) {
          context.read<RecordingTimerCubit>().start();
        } else if (state is RecitationReady) {
          context.read<RecordingTimerCubit>().stop();
        } else if (state is RecitationIdle) {
          context.read<RecordingTimerCubit>().reset();
          setState(() => _showAllText = false);
        }
      },
      child: _MistakeToastListener(
        child: BlocBuilder<RecitationCubit, RecitationState>(
          builder: (context, state) {
            final isReady =
                state is RecitationReady || state is RecitationListening;
            final isListening = state is RecitationListening;
            final mistakeCount = _countMistakes(state);

            return Scaffold(
              appBar: _buildAppBar(context, state),
              drawer: const RecitationDrawer(),
              body: _buildBody(context, state),
              bottomNavigationBar: RecitationBottomToolbar(
                isListening: isListening,
                mistakeCount: mistakeCount,
              ),
              floatingActionButton: RecitationFab(
                isReady: isReady,
                isListening: isListening,
                onStart: () {
                    setState(() => _showAllText = false);
                    context.read<RecitationCubit>().startRecitation();
                },
                onStop: () =>
                    context.read<RecitationCubit>().stopRecitation(),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endDocked,
            );
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
      BuildContext context, RecitationState state) {
    String title = 'Quran Recitation Coach';
    String? subtitle;

    if (state is RecitationReady) {
      title = state.surahName;
      subtitle = '${state.ayahs.length} ayahs';
    } else if (state is RecitationListening) {
      title = state.surahName;
      subtitle = '${state.ayahs.length} ayahs';
    }

    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          if (subtitle != null)
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .appBarTheme
                        .foregroundColor
                        ?.withAlpha(179),
                  ),
            ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(
            _showAllText ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            if (state is RecitationListening) {
              context.read<RecitationCubit>().stopRecitation();
            }
            setState(() => _showAllText = !_showAllText);
          },
          tooltip: _showAllText ? 'Hide text' : 'Show text',
        ),
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            setState(() => _showAllText = false);
            context.read<RecitationCubit>().resetRecitation();
          },
          tooltip: 'Reset',
        ),
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          onPressed: () => _showSettings(context),
          tooltip: 'Settings',
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context, RecitationState state) {
    if (state is RecitationIdle) {
      return Center(
        child: Text(
          'Select a surah to begin',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withAlpha(153),
              ),
        ),
      );
    }

    if (state is RecitationLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is RecitationError) {
      return Center(
        child: Text(
          state.message,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
        ),
      );
    }

    if (state is RecitationReady) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: BlocBuilder<SettingsCubit, SettingsState>(
            builder: (context, settings) {
              return SurahDisplay(
                ayahs: state.ayahs,
                showHelpWords: settings.showHelpWords,
                showAllText: _showAllText,
              );
            },
          ),
        ),
      );
    }

    if (state is RecitationListening) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: BlocBuilder<SettingsCubit, SettingsState>(
            builder: (context, settings) {
              return SurahDisplay(
                ayahs: state.ayahs,
                progress: state.progress,
                showHelpWords: settings.showHelpWords,
                showAllText: _showAllText,
              );
            },
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  int _countMistakes(RecitationState state) {
    if (state is RecitationListening) {
      var count = 0;
      for (final statuses in state.progress.ayahWordStatuses.values) {
        count += statuses.where((s) => s == WordStatus.mistake).length;
      }
      return count;
    }
    return 0;
  }

  void _showSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (bottomSheetContext) {
        return BlocBuilder<SettingsCubit, SettingsState>(
          bloc: context.read<SettingsCubit>(),
          builder: (_, settings) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Settings',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    SwitchListTile(
                      title: const Text('Show help words'),
                      subtitle: const Text(
                        'Preview the next word while reciting',
                      ),
                      value: settings.showHelpWords,
                      onChanged: (_) {
                        context.read<SettingsCubit>().toggleShowHelpWords();
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _MistakeToastListener extends StatefulWidget {
  final Widget child;

  const _MistakeToastListener({required this.child});

  @override
  State<_MistakeToastListener> createState() => _MistakeToastListenerState();
}

class _MistakeToastListenerState extends State<_MistakeToastListener> {
  int _previousMistakeCount = 0;
  bool _isToastVisible = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<RecitationCubit, RecitationState>(
      listener: (context, state) {
        if (state is RecitationListening) {
          var currentMistakes = 0;
          for (final statuses in state.progress.ayahWordStatuses.values) {
            currentMistakes +=
                statuses.where((s) => s == WordStatus.mistake).length;
          }
          if (currentMistakes > _previousMistakeCount && !_isToastVisible) {
            _isToastVisible = true;
            ScaffoldMessenger.of(context)
                .showSnackBar(
                  SnackBar(
                    content: const Text('Mistake detected'),
                    backgroundColor: Theme.of(context).colorScheme.error,
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 2),
                  ),
                )
                .closed
                .then((_) => _isToastVisible = false);
          }
          _previousMistakeCount = currentMistakes;
        } else if (state is RecitationIdle || state is RecitationReady) {
          _previousMistakeCount = 0;
        }
      },
      child: widget.child,
    );
  }
}
