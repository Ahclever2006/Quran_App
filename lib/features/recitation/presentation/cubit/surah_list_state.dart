import 'package:equatable/equatable.dart';
import '../../domain/entities/surah.dart';

abstract class SurahListState extends Equatable {
  const SurahListState();

  @override
  List<Object> get props => [];
}

class SurahListInitial extends SurahListState {
  const SurahListInitial();
}

class SurahListLoading extends SurahListState {
  const SurahListLoading();
}

class SurahListLoaded extends SurahListState {
  final List<Surah> surahs;

  const SurahListLoaded(this.surahs);

  @override
  List<Object> get props => [surahs];
}

class SurahListError extends SurahListState {
  final String message;

  const SurahListError(this.message);

  @override
  List<Object> get props => [message];
}
