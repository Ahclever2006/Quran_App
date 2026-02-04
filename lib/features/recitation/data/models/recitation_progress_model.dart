import '../../domain/entities/recitation_progress.dart';

class RecitationProgressModel extends RecitationProgress {
  const RecitationProgressModel({
    required super.currentWordIndex,
    required super.wordStatuses,
  });

  factory RecitationProgressModel.fromJson(Map<String, dynamic> json) {
    final statuses = (json['word_statuses'] as List<dynamic>)
        .map((s) => _parseWordStatus(s as String))
        .toList();
    return RecitationProgressModel(
      currentWordIndex: json['current_word_index'] as int,
      wordStatuses: statuses,
    );
  }

  static WordStatus _parseWordStatus(String status) {
    switch (status) {
      case 'confirmed':
        return WordStatus.confirmed;
      case 'cursor':
        return WordStatus.cursor;
      case 'mistake':
        return WordStatus.mistake;
      default:
        return WordStatus.pending;
    }
  }
}
