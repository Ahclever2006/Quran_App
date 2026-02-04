import '../../domain/entities/ayah.dart';

class AyahModel extends Ayah {
  AyahModel({
    required super.number,
    required super.text,
    required super.surahNumber,
    required super.numberInSurah,
  });

  factory AyahModel.fromJson(Map<String, dynamic> json) {
    final surah = json['surah'] as Map<String, dynamic>?;
    return AyahModel(
      number: json['number'] as int,
      text: json['text'] as String,
      surahNumber: surah?['number'] as int? ?? 0,
      numberInSurah: json['numberInSurah'] as int,
    );
  }
}
