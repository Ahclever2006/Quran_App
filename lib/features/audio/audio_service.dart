import 'dart:typed_data';

abstract class AudioService {
  Stream<Uint8List> get audioStream;
  Future<void> startRecording();
  Future<void> stopRecording();
  bool get isRecording;
}
