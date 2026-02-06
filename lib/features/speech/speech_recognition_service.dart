import 'dart:async';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechRecognitionService {
  final SpeechToText _speech = SpeechToText();
  final _recognizedTextController = StreamController<String>.broadcast();
  bool _isListening = false;
  bool _shouldBeListening = false;

  Stream<String> get recognizedWords => _recognizedTextController.stream;
  bool get isListening => _isListening;

  Future<bool> initialize() async {
    return await _speech.initialize(
      onError: (error) {
        _isListening = false;
        // Auto-restart if the session timed out but user hasn't stopped
        if (_shouldBeListening && error.errorMsg == 'error_speech_timeout') {
          _restartListening();
        }
      },
      onStatus: (status) {
        if (status == 'notListening' && _shouldBeListening) {
          _restartListening();
        }
      },
    );
  }

  Future<void> startListening() async {
    _shouldBeListening = true;
    await _beginListenSession();
  }

  Future<void> _beginListenSession() async {
    if (!_shouldBeListening) return;
    _isListening = true;
    await _speech.listen(
      onResult: _onResult,
      localeId: 'ar',
      listenOptions: SpeechListenOptions(
        listenMode: ListenMode.dictation,
        cancelOnError: false,
        partialResults: true,
      ),
    );
  }

  void _onResult(SpeechRecognitionResult result) {
    if (result.recognizedWords.isNotEmpty) {
      _recognizedTextController.add(result.recognizedWords);
    }
  }

  Future<void> _restartListening() async {
    // Small delay before restarting to avoid rapid cycling
    await Future.delayed(const Duration(milliseconds: 300));
    if (_shouldBeListening) {
      await _beginListenSession();
    }
  }

  Future<void> stopListening() async {
    _shouldBeListening = false;
    _isListening = false;
    await _speech.stop();
  }

  void dispose() {
    _shouldBeListening = false;
    _isListening = false;
    _speech.stop();
    _recognizedTextController.close();
  }
}
