import 'package:equatable/equatable.dart';

enum WordStatus { pending, confirmed, cursor, mistake }

class RecitationProgress extends Equatable {
  final int currentAyahIndex;
  final int currentWordIndex;
  final Map<int, List<WordStatus>> ayahWordStatuses;

  const RecitationProgress({
    required this.currentAyahIndex,
    required this.currentWordIndex,
    required this.ayahWordStatuses,
  });

  @override
  List<Object> get props =>
      [currentAyahIndex, currentWordIndex, ayahWordStatuses];
}
