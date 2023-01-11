import 'package:dio/dio.dart';

/// A validated [Dio] response
abstract class ValidatedResponse<U, T> {
  /// The raw response data, if available
  Response? get response;

  /// Constructor
  const ValidatedResponse();

  /// Create a validation success response
  factory ValidatedResponse.success(T data, Response<U> response) =>
      SuccessResponse._(data, response);

  /// Create a validation error response
  factory ValidatedResponse.failure(
    Object error,
    StackTrace stacktrace, {
    Response? response,
  }) =>
      FailureResponse._(error, stacktrace, response: response);

  /// Get the success data, if available
  SuccessResponse<U, T>? get success =>
      this is SuccessResponse<U, T> ? this as SuccessResponse<U, T> : null;

  /// Get the error data, if available
  FailureResponse<U, T>? get failure =>
      this is FailureResponse<U, T> ? this as FailureResponse<U, T> : null;
}

/// A successful [ValidatedResponse]
class SuccessResponse<U, T> extends ValidatedResponse<U, T> {
  /// The transformed response data
  final T data;

  @override
  final Response<U> response;

  SuccessResponse._(this.data, this.response);
}

/// An error [ValidatedResponse]
class FailureResponse<U, T> extends ValidatedResponse<U, T> {
  /// The error
  final Object error;

  /// The stacktrace
  final StackTrace stacktrace;

  @override
  final Response? response;

  FailureResponse._(
    this.error,
    this.stacktrace, {
    this.response,
  });

  @override
  String toString() => '$error\n$stacktrace';

  /// Cast a [FailureResponse] to different types
  FailureResponse<RU, RT> cast<RU, RT>() =>
      FailureResponse._(error, stacktrace, response: response);
}
