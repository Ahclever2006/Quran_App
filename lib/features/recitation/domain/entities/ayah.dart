import 'package:equatable/equatable.dart';

class Ayah extends Equatable {
  final int number;
  final String text;
  final int surahNumber;
  final int numberInSurah;
  final List<String> words;

  Ayah({
    required this.number,
    required this.text,
    required this.surahNumber,
    required this.numberInSurah,
  }) : words = text.split(' ');

  @override
  List<Object> get props => [number, text, surahNumber, numberInSurah];
}
