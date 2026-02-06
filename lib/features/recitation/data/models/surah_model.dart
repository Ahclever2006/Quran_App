import '../../domain/entities/surah.dart';

class SurahModel extends Surah {
  const SurahModel({
    required super.number,
    required super.name,
    required super.englishName,
    required super.englishNameTranslation,
    required super.numberOfAyahs,
    required super.revelationType,
  });

  factory SurahModel.fromJson(Map<String, dynamic> json) {
    return SurahModel(
      number: json['number'] as int,
      name: json['name'] as String,
      englishName: json['englishName'] as String,
      englishNameTranslation: json['englishNameTranslation'] as String,
      numberOfAyahs: json['numberOfAyahs'] as int,
      revelationType: json['revelationType'] as String,
    );
  }

  factory SurahModel.fromMetadata(Map<String, dynamic> metadata) {
    return SurahModel(
      number: metadata['number'] as int,
      name: metadata['name'] as String,
      englishName: metadata['englishName'] as String,
      englishNameTranslation: metadata['englishNameTranslation'] as String,
      numberOfAyahs: metadata['numberOfAyahs'] as int,
      revelationType: metadata['revelationType'] as String,
    );
  }
}
