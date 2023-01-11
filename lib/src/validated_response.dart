import 'package:dio/dio.dart';

/// A validated [Dio] response
/// - [U] is the raw response data type
/// - [T] is the transformed response data type
abstract class ValidatedResponse<U, T> {
  /// The raw response data, if available
  Response? get response;

  /// Constructor
  const ValidatedResponse();

  /// Create a validation success response
  factory ValidatedResponse.success(T data, Response<U> response) =>
      ValidResponse._(data, response);

  /// Create a validation failure response
  factory ValidatedResponse.failure(
    Object error,
    StackTrace stacktrace, {
    Response? response,
  }) =>
      InvalidResponse._(error, stacktrace, response: response);

  /// Get the success data, if available
  ValidResponse<U, T>? get success =>
      this is ValidResponse<U, T> ? this as ValidResponse<U, T> : null;

  /// Get the failure data, if available
  InvalidResponse<U, T>? get failure =>
      this is InvalidResponse<U, T> ? this as InvalidResponse<U, T> : null;
}

/// A valid [ValidatedResponse]
class ValidResponse<U, T> extends ValidatedResponse<U, T> {
  /// The transformed response data
  final T data;

  @override
  final Response<U> response;

  ValidResponse._(this.data, this.response);
}

/// An invalid [ValidatedResponse]
class InvalidResponse<U, T> extends ValidatedResponse<U, T> {
  /// The error
  final Object error;

  /// The stacktrace
  final StackTrace stacktrace;

  @override
  final Response? response;

  InvalidResponse._(
    this.error,
    this.stacktrace, {
    this.response,
  });

  @override
  String toString() => '$error\n$stacktrace';

  /// Cast an [InvalidResponse] to different types
  InvalidResponse<RU, RT> cast<RU, RT>() =>
      InvalidResponse._(error, stacktrace, response: response);
}
