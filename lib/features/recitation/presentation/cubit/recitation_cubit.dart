import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/recitation_progress.dart';
import '../../domain/usecases/get_surah_ayahs.dart';
import '../../../speech/speech_recognition_service.dart';
import '../../../speech/recitation_matching_service.dart';
import 'recitation_state.dart';

class RecitationCubit extends Cubit<RecitationState> {
  final GetSurahAyahs _getSurahAyahs;
  final SpeechRecognitionService _speechService;
  final RecitationMatchingService _matchingService;
  StreamSubscription<RecitationProgress>? _progressSubscription;
  StreamSubscription<String>? _speechSubscription;

  RecitationCubit({
    required GetSurahAyahs getSurahAyahs,
    required SpeechRecognitionService speechService,
    required RecitationMatchingService matchingService,
  })  : _getSurahAyahs = getSurahAyahs,
        _speechService = speechService,
        _matchingService = matchingService,
        super(const RecitationIdle());

  Future<void> loadSurah(int surahNumber, String surahName) async {
    emit(const RecitationLoading());
    final result = await _getSurahAyahs(
      GetSurahAyahsParams(surahNumber: surahNumber),
    );
    result.fold(
      (failure) => emit(RecitationError(failure.message)),
      (ayahs) => emit(RecitationReady(ayahs: ayahs, surahName: surahName)),
    );
  }

  Future<void> startRecitation() async {
    final currentState = state;
    if (currentState is! RecitationReady &&
        currentState is! RecitationListening) {
      return;
    }

    final ayahs = currentState is RecitationReady
        ? currentState.ayahs
        : (currentState as RecitationListening).ayahs;
    final surahName = currentState is RecitationReady
        ? currentState.surahName
        : (currentState as RecitationListening).surahName;

    final available = await _speechService.initialize();
    if (!available) {
      emit(const RecitationError('Speech recognition not available'));
      return;
    }

    _matchingService.initialize(ayahs);

    // Listen for progress updates from matching service
    _progressSubscription = _matchingService.progressStream.listen(
      (progress) {
        if (state is RecitationListening) {
          emit(RecitationListening(
            ayahs: ayahs,
            surahName: surahName,
            progress: progress,
          ));
        }
      },
    );

    // Listen for recognized text and feed to matching service
    _speechSubscription = _speechService.recognizedWords.listen(
      (text) {
        _matchingService.processRecognizedText(text);
      },
    );

    // Emit initial listening state
    final initialStatuses = <int, List<WordStatus>>{};
    for (var i = 0; i < ayahs.length; i++) {
      final statuses = List.filled(
          ayahs[i].recitationWords.length, WordStatus.pending);
      if (i == 0 && statuses.isNotEmpty) {
        statuses[0] = WordStatus.cursor;
      }
      initialStatuses[i] = statuses;
    }

    emit(RecitationListening(
      ayahs: ayahs,
      surahName: surahName,
      progress: RecitationProgress(
        currentAyahIndex: 0,
        currentWordIndex: 0,
        ayahWordStatuses: initialStatuses,
      ),
    ));

    await _speechService.startListening();
  }

  Future<void> stopRecitation() async {
    await _speechService.stopListening();
    _speechSubscription?.cancel();
    _speechSubscription = null;
    _progressSubscription?.cancel();
    _progressSubscription = null;

    final currentState = state;
    if (currentState is RecitationListening) {
      emit(RecitationReady(
        ayahs: currentState.ayahs,
        surahName: currentState.surahName,
      ));
    }
  }

  Future<void> resetRecitation() async {
    await stopRecitation();
    emit(const RecitationIdle());
  }

  @override
  Future<void> close() {
    _speechSubscription?.cancel();
    _progressSubscription?.cancel();
    _speechService.dispose();
    _matchingService.dispose();
    return super.close();
  }
}
