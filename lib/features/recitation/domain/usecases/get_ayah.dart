import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/ayah.dart';
import '../repositories/recitation_repository.dart';

class GetAyah extends UseCase<Ayah, GetAyahParams> {
  final RecitationRepository repository;

  const GetAyah(this.repository);

  @override
  Future<Either<Failure, Ayah>> call(GetAyahParams params) {
    return repository.getAyah(params.surahNumber, params.ayahNumber);
  }
}

class GetAyahParams extends Equatable {
  final int surahNumber;
  final int ayahNumber;

  const GetAyahParams({
    required this.surahNumber,
    required this.ayahNumber,
  });

  @override
  List<Object> get props => [surahNumber, ayahNumber];
}
