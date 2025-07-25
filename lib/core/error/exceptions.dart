class ServerException implements Exception {
  final String message;
  final int statusCode;

  const ServerException({required this.message, required this.statusCode});
}

class AuthException implements Exception {
  final String message;
  final int statusCode;

  const AuthException({required this.message, required this.statusCode});
}

class NetworkException implements Exception {
  final String message;
  final int statusCode;

  const NetworkException({required this.message, required this.statusCode});
}
