import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/ayah.dart';
import '../../domain/entities/recitation_progress.dart';
import '../../domain/entities/surah.dart';
import '../../domain/repositories/recitation_repository.dart';
import '../datasources/quran_remote_data_source.dart';
import '../datasources/recitation_socket_data_source.dart';

class RecitationRepositoryImpl implements RecitationRepository {
  final QuranRemoteDataSource remoteDataSource;
  final RecitationSocketDataSource socketDataSource;

  const RecitationRepositoryImpl({
    required this.remoteDataSource,
    required this.socketDataSource,
  });

  @override
  Future<Either<Failure, List<Surah>>> getSurahList() async {
    try {
      final surahs = await remoteDataSource.getSurahList();
      return Right(surahs);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ConnectionFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Ayah>> getAyah(
      int surahNumber, int ayahNumber) async {
    try {
      final ayah = await remoteDataSource.getAyah(surahNumber, ayahNumber);
      return Right(ayah);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ConnectionFailure(e.toString()));
    }
  }

  @override
  Stream<RecitationProgress> connectRecitationSocket(
      int surahNumber, int ayahNumber, int totalWords) {
    return socketDataSource.connect(surahNumber, ayahNumber, totalWords);
  }

  @override
  void disconnectRecitationSocket() {
    socketDataSource.disconnect();
  }
}
