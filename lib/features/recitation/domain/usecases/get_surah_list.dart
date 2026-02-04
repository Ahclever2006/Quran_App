import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/surah.dart';
import '../repositories/recitation_repository.dart';

class GetSurahList {
  final RecitationRepository repository;

  const GetSurahList(this.repository);

  Future<Either<Failure, List<Surah>>> call() {
    return repository.getSurahList();
  }
}
