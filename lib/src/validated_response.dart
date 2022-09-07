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
      ErrorResponse._(ValidationError._(error, stacktrace), response: response);

  /// Get the success data, if available
  SuccessResponse<T>? get success =>
      this is SuccessResponse<T> ? this as SuccessResponse<T> : null;

  /// Get the error data, if available
  ErrorResponse<T>? get error =>
      this is ErrorResponse<T> ? this as ErrorResponse<T> : null;
}

/// A successful [ValidatedResponse]
class SuccessResponse<T> extends ValidatedResponse<T> {
  /// The transformed response data
  final T data;

  @override
  final Response response;

  SuccessResponse._(this.data, this.response);
}

/// An error [ValidatedResponse]
class ErrorResponse<T> extends ValidatedResponse<T> {
  /// The validation error
  final ValidationError validationError;

  @override
  final Response? response;

  ErrorResponse._(
    this.validationError, {
    this.response,
  });
}

/// An error that occurred during validation
class ValidationError {
  /// The error
  final Object error;

  /// The stacktrace
  final StackTrace stacktrace;

  ValidationError._(this.error, this.stacktrace);

  @override
  String toString() => '$error\n$stacktrace';
}
