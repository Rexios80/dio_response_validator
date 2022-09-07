import 'package:dio/dio.dart';
import 'package:dio_response_validator/src/validated_response.dart';

/// Extension on [Dio] [Response] futures for validation
extension DioResponseValidator on Future<Response> {
  /// Handle errors, validate the response, and optionally [transform] the data
  Future<ValidatedResponse<T>> validate<T>({
    T Function(dynamic)? transform,
  }) async {
    final Response response;

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
      final data = transform?.call(responseData) ?? responseData;
      return ValidatedResponse.success(data, response);
    } catch (e, stacktrace) {
      return ValidatedResponse.error(e, stacktrace, response: response);
    }
  }
}
