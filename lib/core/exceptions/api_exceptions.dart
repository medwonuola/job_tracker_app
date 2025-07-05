abstract class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? errorCode;

  const ApiException(this.message, {this.statusCode, this.errorCode});

  @override
  String toString() => message;
}

class NetworkException extends ApiException {
  const NetworkException(super.message);
}

class AuthenticationException extends ApiException {
  const AuthenticationException(super.message) : super(statusCode: 401, errorCode: 'AUTH_FAILED');
}

class RateLimitException extends ApiException {
  const RateLimitException(super.message) : super(statusCode: 429, errorCode: 'RATE_LIMIT');
}

class ServerException extends ApiException {
  const ServerException(super.message, {super.statusCode});
}
