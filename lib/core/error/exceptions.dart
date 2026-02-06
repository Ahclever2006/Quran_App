class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException(this.message, {this.statusCode});

  @override
  String toString() => 'ServerException: $message (status: $statusCode)';
}

class ConnectionException implements Exception {
  final String message;

  const ConnectionException(this.message);

  @override
  String toString() => 'ConnectionException: $message';
}

class WebSocketException implements Exception {
  final String message;

  const WebSocketException(this.message);

  @override
  String toString() => 'WebSocketException: $message';
}

class CacheException implements Exception {
  final String message;

  const CacheException(this.message);

  @override
  String toString() => 'CacheException: $message';
}
