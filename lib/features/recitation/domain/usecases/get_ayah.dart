import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/ayah.dart';
import '../repositories/recitation_repository.dart';

class GetAyah {
  final RecitationRepository repository;

  const GetAyah(this.repository);

  Future<Either<Failure, Ayah>> call(int surahNumber, int ayahNumber) {
    return repository.getAyah(surahNumber, ayahNumber);
  }
}
