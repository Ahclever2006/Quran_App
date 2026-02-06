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
    // The JSON text ends with a non-breaking space (\u00A0) + Arabic-Indic
    // digit(s) as the ayah number marker. Strip that before splitting.
    final stripped = text.replaceAll(RegExp('\u00A0[\u0660-\u0669]+\$'), '');
    return stripped.split(' ').where((w) => w.isNotEmpty).toList();
  }

  @override
  List<Object> get props => [number, text, surahNumber, numberInSurah];
}
