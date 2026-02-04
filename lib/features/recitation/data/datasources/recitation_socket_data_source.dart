import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/recitation_progress_model.dart';

abstract class RecitationSocketDataSource {
  Stream<RecitationProgressModel> connect(
      int surahNumber, int ayahNumber, int totalWords);
  void disconnect();
}

class RecitationSocketDataSourceImpl implements RecitationSocketDataSource {
  WebSocketChannel? _channel;
  StreamController<RecitationProgressModel>? _controller;

  @override
  Stream<RecitationProgressModel> connect(
      int surahNumber, int ayahNumber, int totalWords) {
    _controller = StreamController<RecitationProgressModel>.broadcast();

    try {
      final uri = Uri.parse(
        '${ApiConstants.webSocketBaseUrl}${ApiConstants.recitationSocketPath}'
        '?surah=$surahNumber&ayah=$ayahNumber&total_words=$totalWords',
      );
      _channel = WebSocketChannel.connect(uri);

      _channel!.stream.listen(
        (data) {
          final json = jsonDecode(data as String) as Map<String, dynamic>;
          final progress = RecitationProgressModel.fromJson(json);
          _controller?.add(progress);
        },
        onError: (Object error) {
          _controller?.addError(
            const WebSocketException('WebSocket stream error'),
          );
        },
        onDone: () {
          _controller?.close();
        },
      );
    } catch (e) {
      _controller?.addError(
        const WebSocketException('Failed to connect to WebSocket'),
      );
    }

    return _controller!.stream;
  }

  @override
  void disconnect() {
    _channel?.sink.close();
    _controller?.close();
    _channel = null;
    _controller = null;
  }
}
