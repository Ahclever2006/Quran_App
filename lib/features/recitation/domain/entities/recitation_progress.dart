import 'package:equatable/equatable.dart';

enum WordStatus { pending, confirmed, cursor, mistake }

class RecitationProgress extends Equatable {
  final int currentWordIndex;
  final List<WordStatus> wordStatuses;

  const RecitationProgress({
    required this.currentWordIndex,
    required this.wordStatuses,
  });

  @override
  List<Object> get props => [currentWordIndex, wordStatuses];
}
