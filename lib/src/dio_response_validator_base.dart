import 'package:dio/dio.dart';
import 'package:dio_response_validator/src/validated_response.dart';

/// Extension on [Dio] [Response] futures for validation
extension DioResponseValidator<U> on Future<Response<U>> {
  /// Handle errors and validate the response
  Future<ValidatedResponse<U>> validate() async {
    final Response<U> response;

    try {
      response = await this;
      return ValidResponse<U, U>(response.data as U, response);
    } on DioException catch (e, stacktrace) {
      return InvalidResponse(e, stacktrace, response: e.response);
    } catch (e, stacktrace) {
      return InvalidResponse(e, stacktrace);
    }
  }
}

/// Extension on [ValidatedResponse] for transforming the response data
extension ValidatedResponseTransformer<U> on Future<TransformedResponse<U, U>> {
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

    final response = await this;
    switch (response) {
      case ValidResponse(data: final data):
        try {
          if (transform == null) {
            return ValidResponse(data as T, response.response);
          }

          return ValidResponse(transform(response.data), response.response);
        } catch (e, stacktrace) {
          return InvalidResponse(e, stacktrace, response: response.response);
        }
      case InvalidResponse(error: final error):
        if (transformDioException == null || error is! DioException) {
          return response.cast();
        }

        try {
          return InvalidResponse(
            transformDioException(error),
            response.stacktrace,
            response: response.response,
          );
        } catch (e, stacktrace) {
          return InvalidResponse(e, stacktrace, response: response.response);
        }
    }
  }
}
