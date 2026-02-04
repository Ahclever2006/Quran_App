import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_surah_list.dart';
import 'surah_list_state.dart';

class SurahListCubit extends Cubit<SurahListState> {
  final GetSurahList _getSurahList;

  SurahListCubit({required GetSurahList getSurahList})
      : _getSurahList = getSurahList,
        super(const SurahListInitial());

  Future<void> loadSurahs() async {
    emit(const SurahListLoading());
    final result = await _getSurahList(const NoParams());
    result.fold(
      (failure) => emit(SurahListError(failure.message)),
      (surahs) => emit(SurahListLoaded(surahs)),
    );
  }
}
