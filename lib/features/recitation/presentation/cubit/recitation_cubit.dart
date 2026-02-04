import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/recitation_progress.dart';
import '../../domain/repositories/recitation_repository.dart';
import '../../domain/usecases/get_ayah.dart';
import '../../../audio/audio_service.dart';
import 'recitation_state.dart';

class RecitationCubit extends Cubit<RecitationState> {
  final GetAyah _getAyah;
  final RecitationRepository _repository;
  final AudioService _audioService;
  StreamSubscription<RecitationProgress>? _progressSubscription;

  RecitationCubit({
    required GetAyah getAyah,
    required RecitationRepository repository,
    required AudioService audioService,
  })  : _getAyah = getAyah,
        _repository = repository,
        _audioService = audioService,
        super(const RecitationIdle());

  Future<void> loadAyah(int surahNumber, int ayahNumber) async {
    emit(const RecitationLoading());
    final result = await _getAyah(GetAyahParams(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
    ));
    result.fold(
      (failure) => emit(RecitationError(failure.message)),
      (ayah) => emit(RecitationReady(ayah: ayah)),
    );
  }

  Future<void> startRecitation() async {
    final currentState = state;
    if (currentState is! RecitationReady && currentState is! RecitationListening) {
      return;
    }

    final ayah = currentState is RecitationReady
        ? currentState.ayah
        : (currentState as RecitationListening).ayah;

    await _audioService.startRecording();

    final initialStatuses =
        List.filled(ayah.words.length, WordStatus.pending);
    initialStatuses[0] = WordStatus.cursor;

    emit(RecitationListening(
      ayah: ayah,
      progress: RecitationProgress(
        currentWordIndex: 0,
        wordStatuses: initialStatuses,
      ),
    ));

    _progressSubscription = _repository
        .connectRecitationSocket(
            ayah.surahNumber, ayah.numberInSurah, ayah.words.length)
        .listen(
      (progress) {
        if (state is RecitationListening) {
          emit(RecitationListening(ayah: ayah, progress: progress));
        }
      },
      onError: (Object error) {
        emit(RecitationError(error.toString()));
      },
    );
  }

  Future<void> stopRecitation() async {
    await _audioService.stopRecording();
    _progressSubscription?.cancel();
    _progressSubscription = null;
    _repository.disconnectRecitationSocket();

    final currentState = state;
    if (currentState is RecitationListening) {
      emit(RecitationReady(ayah: currentState.ayah));
    }
  }

  Future<void> resetRecitation() async {
    await stopRecitation();
    emit(const RecitationIdle());
  }

  @override
  Future<void> close() {
    _progressSubscription?.cancel();
    _repository.disconnectRecitationSocket();
    return super.close();
  }
}
