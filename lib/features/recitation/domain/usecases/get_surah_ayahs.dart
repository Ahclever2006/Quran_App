import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/ayah.dart';
import '../repositories/recitation_repository.dart';

class GetSurahAyahs extends UseCase<List<Ayah>, GetSurahAyahsParams> {
  final RecitationRepository repository;

  const GetSurahAyahs(this.repository);

  @override
  Future<Either<Failure, List<Ayah>>> call(GetSurahAyahsParams params) {
    return repository.getSurahAyahs(params.surahNumber);
  }
}

class GetSurahAyahsParams extends Equatable {
  final int surahNumber;

  const GetSurahAyahsParams({required this.surahNumber});

  @override
  List<Object> get props => [surahNumber];
}
