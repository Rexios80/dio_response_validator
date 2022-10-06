import 'package:dio/dio.dart';
import 'package:dio_response_validator/src/validated_response.dart';

/// Extension on [Dio] [Response] futures for validation
extension DioResponseValidator<U> on Future<Response<U>> {
  /// Handle errors, validate the response, and optionally [transform] the data
  Future<ValidatedResponse<T>> validate<T>({
    T Function(U data)? transform,
  }) async {
    final Response<U> response;

    try {
      response = await this;
    } on DioError catch (e, stacktrace) {
      final response = e.response;
      if (response != null) {
        return ValidatedResponse.error(
          e,
          stacktrace,
          response: e.response,
        );
      } else {
        return ValidatedResponse.error(e, stacktrace);
      }
    } catch (e, stacktrace) {
      return ValidatedResponse.error(e, stacktrace);
    }

    final responseData = response.data;

    try {
      final data =
          transform != null ? transform(responseData as U) : responseData as T;
      return ValidatedResponse.success(data, response);
    } catch (e, stacktrace) {
      return ValidatedResponse.error(e, stacktrace, response: response);
    }
  }
}
