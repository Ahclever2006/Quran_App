import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/ayah_model.dart';
import '../models/surah_model.dart';

abstract class QuranRemoteDataSource {
  Future<List<SurahModel>> getSurahList();
  Future<AyahModel> getAyah(int surahNumber, int ayahNumber);
}

class QuranRemoteDataSourceImpl implements QuranRemoteDataSource {
  final Dio dio;

  const QuranRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<SurahModel>> getSurahList() async {
    try {
      final response = await dio.get(ApiConstants.surahListEndpoint);
      final data = response.data['data'] as List<dynamic>;
      return data
          .map((json) => SurahModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        e.message ?? 'Failed to fetch surah list',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<AyahModel> getAyah(int surahNumber, int ayahNumber) async {
    try {
      final response =
          await dio.get(ApiConstants.ayahEndpoint(surahNumber, ayahNumber));
      final data = response.data['data'] as Map<String, dynamic>;
      return AyahModel.fromJson(data);
    } on DioException catch (e) {
      throw ServerException(
        e.message ?? 'Failed to fetch ayah',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
