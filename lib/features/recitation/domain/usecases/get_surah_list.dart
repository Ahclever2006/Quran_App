import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/surah.dart';
import '../repositories/recitation_repository.dart';

class GetSurahList extends UseCase<List<Surah>, NoParams> {
  final RecitationRepository repository;

  const GetSurahList(this.repository);

  @override
  Future<Either<Failure, List<Surah>>> call(NoParams params) {
    return repository.getSurahList();
  }
}
