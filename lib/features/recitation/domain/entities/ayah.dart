import 'package:equatable/equatable.dart';

class Ayah extends Equatable {
  final int number;
  final String text;
  final int surahNumber;
  final int numberInSurah;
  final List<String> words;
  final List<String> recitationWords;

  Ayah({
    required this.number,
    required this.text,
    required this.surahNumber,
    required this.numberInSurah,
  })  : words = text.split(' '),
        recitationWords = _buildRecitationWords(text);

  static List<String> _buildRecitationWords(String text) {
    final allWords = text.split(' ');
    if (allWords.isEmpty) return allWords;
    final last = allWords.last;
    // The trailing word is the ayah number marker if it's purely
    // Arabic-Indic digits (٠١٢٣٤٥٦٧٨٩) — strip it for matching.
    final isAyahNumber = RegExp(r'^[٠-٩]+$').hasMatch(last);
    return isAyahNumber ? allWords.sublist(0, allWords.length - 1) : allWords;
  }

  @override
  List<Object> get props => [number, text, surahNumber, numberInSurah];
}
