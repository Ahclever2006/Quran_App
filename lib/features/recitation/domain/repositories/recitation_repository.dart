import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/ayah.dart';
import '../entities/recitation_progress.dart';
import '../entities/surah.dart';

abstract class RecitationRepository {
  Future<Either<Failure, List<Surah>>> getSurahList();
  Future<Either<Failure, Ayah>> getAyah(int surahNumber, int ayahNumber);
  Stream<RecitationProgress> connectRecitationSocket(
      int surahNumber, int ayahNumber, int totalWords);
  void disconnectRecitationSocket();
}
