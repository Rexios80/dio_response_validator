import 'package:dio/dio.dart';

typedef ValidatedResponse<U> = TransformedResponse<U, U>;

sealed class TransformedResponse<U, T> {
  /// The raw response data, if available
  Response? get response;

  const TransformedResponse();
}

/// A valid [ValidatedResponse]
/// - [U] is the raw response data type
/// - [T] is the transformed response data type
class ValidResponse<U, T> extends TransformedResponse<U, T> {
  /// The transformed response data
  final T data;

  @override
  final Response<U> response;

  /// Constructor
  const ValidResponse(this.data, this.response);
}

/// An invalid [ValidatedResponse]
class InvalidResponse<U, T> extends TransformedResponse<U, T> {
  /// The error
  final Object error;

  /// The stacktrace
  final StackTrace stacktrace;

  @override
  final Response? response;

  /// Constructor
  const InvalidResponse(
    this.error,
    this.stacktrace, {
    this.response,
  });

  @override
  String toString() => '$error\n$stacktrace';

  /// Cast an [InvalidResponse] to different types
  InvalidResponse<RU, RT> cast<RU, RT>() =>
      InvalidResponse(error, stacktrace, response: response);
}
