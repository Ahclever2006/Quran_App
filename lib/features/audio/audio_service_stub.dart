import 'dart:async';
import 'dart:typed_data';
import 'audio_service.dart';

class AudioServiceStub implements AudioService {
  final _controller = StreamController<Uint8List>.broadcast();
  bool _isRecording = false;

  @override
  Stream<Uint8List> get audioStream => _controller.stream;

  @override
  bool get isRecording => _isRecording;

  @override
  Future<void> startRecording() async {
    _isRecording = true;
  }

  @override
  Future<void> stopRecording() async {
    _isRecording = false;
  }
}
