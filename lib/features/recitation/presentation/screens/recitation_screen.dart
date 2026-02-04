import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/recitation_cubit.dart';
import '../cubit/recitation_state.dart';
import '../widgets/ayah_word_display.dart';
import '../widgets/recitation_controls.dart';
import '../widgets/surah_selector.dart';

class RecitationScreen extends StatelessWidget {
  const RecitationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quran Recitation Coach'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SurahSelector(
              onAyahSelected: (surahNumber, ayahNumber) {
                context
                    .read<RecitationCubit>()
                    .loadAyah(surahNumber, ayahNumber);
              },
            ),
            const SizedBox(height: 24),
            Expanded(
              child: BlocBuilder<RecitationCubit, RecitationState>(
                builder: (context, state) {
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
                    return Center(
                      child: AyahWordDisplay(ayah: state.ayah),
                    );
                  }

                  if (state is RecitationListening) {
                    return Center(
                      child: AyahWordDisplay(
                        ayah: state.ayah,
                        progress: state.progress,
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
            const SizedBox(height: 16),
            BlocBuilder<RecitationCubit, RecitationState>(
              builder: (context, state) {
                final isReady =
                    state is RecitationReady || state is RecitationListening;
                final isListening = state is RecitationListening;

                return RecitationControls(
                  isListening: isListening,
                  isReady: isReady,
                  onStart: () =>
                      context.read<RecitationCubit>().startRecitation(),
                  onStop: () =>
                      context.read<RecitationCubit>().stopRecitation(),
                  onReset: () =>
                      context.read<RecitationCubit>().resetRecitation(),
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
