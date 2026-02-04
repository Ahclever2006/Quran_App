import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/recitation_progress.dart';
import '../cubit/recitation_cubit.dart';
import '../cubit/recitation_state.dart';
import '../cubit/recording_timer_cubit.dart';
import '../cubit/surah_list_cubit.dart';
import '../cubit/surah_list_state.dart';
import '../widgets/ayah_word_display.dart';
import '../widgets/recitation_bottom_toolbar.dart';
import '../widgets/recitation_drawer.dart';
import '../widgets/recitation_fab.dart';

class RecitationScreen extends StatelessWidget {
  const RecitationScreen({super.key});

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
                onReset: () =>
                    context.read<RecitationCubit>().resetRecitation(),
              ),
              floatingActionButton: RecitationFab(
                isReady: isReady,
                isListening: isListening,
                onStart: () =>
                    context.read<RecitationCubit>().startRecitation(),
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

    if (state is RecitationReady || state is RecitationListening) {
      final ayah = state is RecitationReady
          ? state.ayah
          : (state as RecitationListening).ayah;

      final surahListState = context.read<SurahListCubit>().state;
      if (surahListState is SurahListLoaded) {
        final surah = surahListState.surahs
            .where((s) => s.number == ayah.surahNumber)
            .firstOrNull;
        if (surah != null) {
          title = surah.englishName;
        }
      }
      subtitle = 'Ayah ${ayah.numberInSurah}';
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
          icon: const Icon(Icons.bookmark_border),
          onPressed: () {},
          tooltip: 'Bookmark',
        ),
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {},
          tooltip: 'Search',
        ),
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          onPressed: () {},
          tooltip: 'Settings',
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context, RecitationState state) {
    if (state is RecitationIdle) {
      return Center(
        child: Text(
          'Select a surah and ayah to begin',
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
          child: AyahWordDisplay(ayah: state.ayah),
        ),
      );
    }

    if (state is RecitationListening) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: AyahWordDisplay(
            ayah: state.ayah,
            progress: state.progress,
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  int _countMistakes(RecitationState state) {
    if (state is RecitationListening) {
      return state.progress.wordStatuses
          .where((s) => s == WordStatus.mistake)
          .length;
    }
    return 0;
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<RecitationCubit, RecitationState>(
      listener: (context, state) {
        if (state is RecitationListening) {
          final currentMistakes = state.progress.wordStatuses
              .where((s) => s == WordStatus.mistake)
              .length;
          if (currentMistakes > _previousMistakeCount) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Mistake detected'),
                backgroundColor: Theme.of(context).colorScheme.error,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 2),
              ),
            );
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
