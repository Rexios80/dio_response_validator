import 'package:dio/dio.dart';

/// A validated response
typedef ValidatedResponse<U, T> = (ValidResponse<U, T>?, InvalidResponse?);

/// A valid [ValidatedResponse]
/// - [U] is the raw response data type
/// - [T] is the transformed response data type
class ValidResponse<U, T> {
  /// The transformed response data
  final T data;

  /// The raw response data
  final Response<U> response;

  /// Constructor
  const ValidResponse(this.data, this.response);
}

/// An invalid [ValidatedResponse]
class InvalidResponse {
  /// The error
  final Object error;

  /// The stacktrace
  final StackTrace stacktrace;

  /// The raw response data, if available
  final Response? response;

  /// Constructor
  const InvalidResponse(
    this.error,
    this.stacktrace, {
    this.response,
  });

  @override
  String toString() => '$error\n$stacktrace';
}
