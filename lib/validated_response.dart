import 'package:dio/dio.dart';

/// A validated [Dio] response
abstract class ValidatedResponse<T> {
  /// The raw response data, if available
  Response? get response;

  /// Constructor
  const ValidatedResponse();

  /// Create a validation success response
  factory ValidatedResponse.success(T data, Response response) =>
      SuccessResponse._(data, response);

  /// Create a validation error response
  factory ValidatedResponse.error(
    Object error,
    StackTrace stacktrace, {
    Response? response,
  }) =>
      ErrorResponse._(ValidationError(error, stacktrace), response: response);
}

/// A successful [ValidatedResponse]
class SuccessResponse<T> extends ValidatedResponse<T> {
  /// The transformed response data
  final T data;

  @override
  final Response response;

  /// Constructor
  SuccessResponse._(this.data, this.response);
}

/// An error [ValidatedResponse]
class ErrorResponse<T> extends ValidatedResponse<T> {
  /// The validation error
  final ValidationError error;

  @override
  final Response? response;

  /// Constructor
  ErrorResponse._(
    this.error, {
    this.response,
  });
}

/// An error that occurred during validation
class ValidationError {
  /// The error
  final Object error;

  /// The stacktrace
  final StackTrace stacktrace;

  /// Constructor
  ValidationError(this.error, this.stacktrace);
}
