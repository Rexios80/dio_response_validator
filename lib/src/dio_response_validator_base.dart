import 'package:dio/dio.dart';
import 'package:dio_response_validator/src/validated_response.dart';

/// Extension on [Dio] [Response] futures for validation
extension DioResponseValidator<U> on Future<Response<U>> {
  /// Handle errors and validate the response
  /// - Optionally transform the data with [transform]
  /// - Optionally transform [DioException]s with [transformDioError]
  Future<ValidatedResponse<U, T>> validate<T>({
    T Function(U data)? transform,
    Object Function(DioException error)? transformDioError,
  }) async {
    final Response<U> response;

    try {
      response = await this;
    } on DioException catch (e, stacktrace) {
      return ValidatedResponse.failure(
        transformDioError != null ? transformDioError(e) : e,
        stacktrace,
        response: e.response,
      );
    } catch (e, stacktrace) {
      return ValidatedResponse.failure(e, stacktrace);
    }

    try {
      return ValidatedResponse.success(
        transform != null ? transform(response.data as U) : response.data as T,
        response,
      );
    } catch (e, stacktrace) {
      return ValidatedResponse.failure(e, stacktrace, response: response);
    }
  }
}
