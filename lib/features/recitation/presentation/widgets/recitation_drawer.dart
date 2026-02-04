import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/recitation_cubit.dart';
import 'surah_selector.dart';

class RecitationDrawer extends StatelessWidget {
  const RecitationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Text(
                'Select Surah & Ayah',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimaryContainer,
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SurahSelector(
                onAyahSelected: (surahNumber, ayahNumber) {
                  context
                      .read<RecitationCubit>()
                      .loadAyah(surahNumber, ayahNumber);
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
