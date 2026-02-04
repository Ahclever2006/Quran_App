import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

class RecordingTimerCubit extends Cubit<Duration> {
  Timer? _timer;

  RecordingTimerCubit() : super(Duration.zero);

  void start() {
    _timer?.cancel();
    emit(Duration.zero);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      emit(state + const Duration(seconds: 1));
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  void reset() {
    _timer?.cancel();
    _timer = null;
    emit(Duration.zero);
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
