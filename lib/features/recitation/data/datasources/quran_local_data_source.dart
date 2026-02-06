import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../../core/constants/surah_metadata.dart';
import '../../../../core/error/exceptions.dart';
import '../models/ayah_model.dart';
import '../models/surah_model.dart';

abstract class QuranLocalDataSource {
  Future<List<SurahModel>> getSurahList();
  Future<List<AyahModel>> getSurahAyahs(int surahNumber);
  Future<AyahModel> getAyah(int surahNumber, int ayahNumber);
}

class QuranLocalDataSourceImpl implements QuranLocalDataSource {
  Map<String, dynamic>? _cachedJson;

  Future<Map<String, dynamic>> _loadJson() async {
    if (_cachedJson != null) return _cachedJson!;
    try {
      final jsonString =
          await rootBundle.loadString('lib/assets/qpc-hafs.json');
      _cachedJson = json.decode(jsonString) as Map<String, dynamic>;
      return _cachedJson!;
    } catch (e) {
      throw CacheException('Failed to load Quran data: $e');
    }
  }

  @override
  Future<List<SurahModel>> getSurahList() async {
    return SurahMetadata.surahs
        .map((metadata) => SurahModel.fromMetadata(metadata))
        .toList();
  }

  @override
  Future<List<AyahModel>> getSurahAyahs(int surahNumber) async {
    final data = await _loadJson();
    final ayahs = <AyahModel>[];
    for (final entry in data.values) {
      final map = entry as Map<String, dynamic>;
      if (map['surah'] == surahNumber) {
        ayahs.add(AyahModel.fromLocalJson(map));
      }
    }
    if (ayahs.isEmpty) {
      throw CacheException('Surah $surahNumber not found in local data');
    }
    ayahs.sort((a, b) => a.numberInSurah.compareTo(b.numberInSurah));
    return ayahs;
  }

  @override
  Future<AyahModel> getAyah(int surahNumber, int ayahNumber) async {
    final data = await _loadJson();
    final key = '$surahNumber:$ayahNumber';
    final entry = data[key];
    if (entry == null) {
      throw CacheException('Ayah $key not found in local data');
    }
    return AyahModel.fromLocalJson(entry as Map<String, dynamic>);
  }
}
