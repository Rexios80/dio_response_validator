import 'package:dio/dio.dart';
import 'package:dio_response_validator/dio_response_validator.dart';
import 'package:test/test.dart';

void main() {
  final dio = Dio();

  test('Validation success', () async {
    final response =
        await dio.get('https://vrchat.com/api/1/config').validate();
    expect(response.success, isNotNull);
  });

  test('Validation failure', () async {
    final response =
        await dio.get('https://vrchat.com/api/2/config').validate();
    expect(response.failure, isNotNull);
    expect(response.failure!.error, isNot(isA<String>()));
  });

  test('Transform DioError', () async {
    final response = await dio.get('https://vrchat.com/api/2/config').validate(
          transformDioError: (error) =>
              error.response?.data['message'] ?? 'Unknown error',
        );
    expect(response.failure!.error, isA<String>());
  });

  test('Transform success', () async {
    final response = await dio
        .get('https://vrchat.com/api/1/config')
        .validate<String>(transform: (data) => data['apiKey']);
    expect(response.success, isNotNull);
  });

  test('Transform failure', () async {
    final response = await dio
        .get('https://vrchat.com/api/1/config')
        .validate<String>(transform: (data) => data['invalid']);
    expect(response.failure, isNotNull);
  });
}
