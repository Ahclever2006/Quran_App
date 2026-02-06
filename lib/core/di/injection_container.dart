import 'package:get_it/get_it.dart';
import '../../features/recitation/data/datasources/quran_local_data_source.dart';
import '../../features/recitation/data/repositories/recitation_repository_impl.dart';
import '../../features/recitation/domain/repositories/recitation_repository.dart';
import '../../features/recitation/domain/usecases/get_surah_ayahs.dart';
import '../../features/recitation/domain/usecases/get_surah_list.dart';
import '../../features/recitation/presentation/cubit/recitation_cubit.dart';
import '../../features/recitation/presentation/cubit/recording_timer_cubit.dart';
import '../../features/recitation/presentation/cubit/surah_list_cubit.dart';
import '../../features/speech/recitation_matching_service.dart';
import '../../features/speech/speech_recognition_service.dart';

final sl = GetIt.instance;

void initDependencies() {
  // Data sources
  sl.registerLazySingleton<QuranLocalDataSource>(
    () => QuranLocalDataSourceImpl(),
  );

  // Repository
  sl.registerLazySingleton<RecitationRepository>(
    () => RecitationRepositoryImpl(localDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetSurahList(sl()));
  sl.registerLazySingleton(() => GetSurahAyahs(sl()));

  // Services
  sl.registerFactory(() => SpeechRecognitionService());
  sl.registerFactory(() => RecitationMatchingService());

  // Cubits
  sl.registerFactory(
    () => SurahListCubit(getSurahList: sl()),
  );
  sl.registerFactory(
    () => RecitationCubit(
      getSurahAyahs: sl(),
      speechService: sl(),
      matchingService: sl(),
    ),
  );
  sl.registerFactory(
    () => RecordingTimerCubit(),
  );
}
