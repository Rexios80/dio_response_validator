import 'package:dio/dio.dart';
import 'package:dio_response_validator/src/validated_response.dart';

/// Extension on [Dio] [Response] futures for validation
extension DioResponseValidator<U> on Future<Response<U>> {
  /// Handle errors and validate the response
  Future<ValidatedResponse<U, U>> validate() async {
    final Response<U> response;

    try {
      response = await this;
    } on DioException catch (e, stacktrace) {
      return (null, InvalidResponse(e, stacktrace, response: e.response));
    } catch (e, stacktrace) {
      return (null, InvalidResponse(e, stacktrace));
    }

    return (ValidResponse(response.data as U, response), null);
  }
}

/// Extension on [ValidatedResponse] for transforming the response data
extension ValidatedResponseTransformer<U> on Future<ValidatedResponse<U, U>> {
  /// Transforms the response data from [U] to [T]
  /// - Optionally transform the data with [transform]
  /// - Optionally transform [DioException]s with [transformDioException]
  Future<ValidatedResponse<U, T>> transform<T>({
    T Function(U data)? transform,
    Object Function(DioException error)? transformDioException,
  }) async {
    assert(
      transform != null || transformDioException != null,
      'Either transform or transformDioException must be provided',
    );

    final (success, failure) = await this;
    if (transform != null && success != null) {
      try {
        return (ValidResponse(transform(success.data), success.response), null);
      } catch (e, stacktrace) {
        return (
          null,
          InvalidResponse(e, stacktrace, response: success.response),
        );
      }
    }

    final error = failure?.error;
    if (transformDioException != null &&
        failure != null &&
        error is DioException) {
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
    }

    throw 'This should never happen';
  }
}
