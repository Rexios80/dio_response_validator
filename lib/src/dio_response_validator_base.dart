import 'package:dio/dio.dart';
import 'package:dio_response_validator/src/validated_response.dart';

/// Extension on [Dio] [Response] futures for validation
extension DioResponseValidator<U> on Future<Response<U>> {
  /// Handle errors and validate the response
  Future<ValidatedResponse<U>> validate() async {
    final Response<U> response;

    try {
      response = await this;
      return (ValidResponse(response.data as U, response), null);
    } on DioException catch (e, stacktrace) {
      return (null, InvalidResponse(e, stacktrace, response: e.response));
    } catch (e, stacktrace) {
      return (null, InvalidResponse(e, stacktrace));
    }
  }
}

/// Extension on [ValidatedResponse] for transforming the response data
extension ValidatedResponseTransformer<U> on Future<ValidatedResponse<U>> {
  /// Transforms the response data from [U] to [T]
  /// - Optionally transform the data with [transform]
  /// - Optionally transform [DioException]s with [transformDioException]
  Future<TransformedResponse<U, T>> transform<T>({
    T Function(U data)? transform,
    Object Function(DioException error)? transformDioException,
  }) async {
    assert(
      transform != null || transformDioException != null,
      'Either transform or transformDioException must be provided',
    );

    final (success, failure) = await this;
    if (success != null) {
      try {
        if (transform == null) {
          return (ValidResponse(success.data as T, success.response), null);
        }

        return (ValidResponse(transform(success.data), success.response), null);
      } catch (e, stacktrace) {
        return (
          null,
          InvalidResponse(e, stacktrace, response: success.response),
        );
      }
    } else if (failure != null) {
      final error = failure.error;
      if (transformDioException == null || error is! DioException) {
        return (null, failure);
      }

      try {
        return (
          null,
          InvalidResponse(
            transformDioException(error),
            failure.stacktrace,
            response: failure.response,
          )
        );
      } catch (e, stacktrace) {
        return (
          null,
          InvalidResponse(e, stacktrace, response: failure.response),
        );
      }
    } else {
      throw StateError('This should never happen');
    }
  }
}
