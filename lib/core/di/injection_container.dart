import 'package:get_it/get_it.dart';
import '../network/api_client.dart';
import '../../features/audio/audio_service.dart';
import '../../features/audio/audio_service_stub.dart';
import '../../features/recitation/data/datasources/quran_remote_data_source.dart';
import '../../features/recitation/data/datasources/recitation_socket_data_source.dart';
import '../../features/recitation/data/repositories/recitation_repository_impl.dart';
import '../../features/recitation/domain/repositories/recitation_repository.dart';
import '../../features/recitation/domain/usecases/get_ayah.dart';
import '../../features/recitation/domain/usecases/get_surah_list.dart';
import '../../features/recitation/presentation/cubit/recitation_cubit.dart';
import '../../features/recitation/presentation/cubit/surah_list_cubit.dart';

final sl = GetIt.instance;

void initDependencies() {
  // Core
  sl.registerLazySingleton(() => ApiClient());

  // Audio
  sl.registerLazySingleton<AudioService>(() => AudioServiceStub());

  // Data sources
  sl.registerLazySingleton<QuranRemoteDataSource>(
    () => QuranRemoteDataSourceImpl(dio: sl<ApiClient>().dio),
  );
  sl.registerLazySingleton<RecitationSocketDataSource>(
    () => RecitationSocketDataSourceImpl(),
  );

  // Repository
  sl.registerLazySingleton<RecitationRepository>(
    () => RecitationRepositoryImpl(
      remoteDataSource: sl(),
      socketDataSource: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetSurahList(sl()));
  sl.registerLazySingleton(() => GetAyah(sl()));

  // Cubits
  sl.registerFactory(
    () => SurahListCubit(getSurahList: sl()),
  );
  sl.registerFactory(
    () => RecitationCubit(
      getAyah: sl(),
      repository: sl(),
      audioService: sl(),
    ),
  );
}
