import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/surah.dart';
import '../cubit/surah_list_cubit.dart';
import '../cubit/surah_list_state.dart';

class SurahSelector extends StatefulWidget {
  final void Function(int surahNumber, int ayahNumber) onAyahSelected;

  const SurahSelector({super.key, required this.onAyahSelected});

  @override
  State<SurahSelector> createState() => _SurahSelectorState();
}

class _SurahSelectorState extends State<SurahSelector> {
  Surah? _selectedSurah;
  final _ayahController = TextEditingController(text: '1');

  @override
  void dispose() {
    _ayahController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SurahListCubit, SurahListState>(
      builder: (context, state) {
        if (state is SurahListLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is SurahListError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  state.message,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                ),
                const SizedBox(height: 8),
                FilledButton(
                  onPressed: () =>
                      context.read<SurahListCubit>().loadSurahs(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state is! SurahListLoaded) {
          return const SizedBox.shrink();
        }

        return Row(
          children: [
            Expanded(
              flex: 3,
              child: DropdownButtonFormField<Surah>(
                initialValue: _selectedSurah,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Surah',
                  border: OutlineInputBorder(),
                ),
                items: state.surahs.map((surah) {
                  return DropdownMenuItem(
                    value: surah,
                    child: Text(
                      '${surah.number}. ${surah.englishName}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (surah) {
                  setState(() {
                    _selectedSurah = surah;
                    _ayahController.text = '1';
                  });
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 1,
              child: TextFormField(
                controller: _ayahController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Ayah',
                  border: const OutlineInputBorder(),
                  hintText: _selectedSurah != null
                      ? '1-${_selectedSurah!.numberOfAyahs}'
                      : '',
                ),
              ),
            ),
            const SizedBox(width: 12),
            FilledButton(
              onPressed: _selectedSurah == null
                  ? null
                  : () {
                      final ayahNum =
                          int.tryParse(_ayahController.text) ?? 1;
                      widget.onAyahSelected(
                          _selectedSurah!.number, ayahNum);
                    },
              child: const Text('Load'),
            ),
          ],
        );
      },
    );
  }
}
