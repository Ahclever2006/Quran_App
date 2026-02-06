import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/ayah.dart';
import '../../domain/entities/surah.dart';
import '../../domain/repositories/recitation_repository.dart';
import '../datasources/quran_local_data_source.dart';

class RecitationRepositoryImpl implements RecitationRepository {
  final QuranLocalDataSource localDataSource;

  const RecitationRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Surah>>> getSurahList() async {
    try {
      final surahs = await localDataSource.getSurahList();
      return Right(surahs);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Ayah>>> getSurahAyahs(int surahNumber) async {
    try {
      final ayahs = await localDataSource.getSurahAyahs(surahNumber);
      return Right(ayahs);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Ayah>> getAyah(
      int surahNumber, int ayahNumber) async {
    try {
      final ayah = await localDataSource.getAyah(surahNumber, ayahNumber);
      return Right(ayah);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
