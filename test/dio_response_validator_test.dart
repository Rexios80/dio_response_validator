import 'package:dio/dio.dart';
import 'package:dio_response_validator/dio_response_validator.dart';
import 'package:test/test.dart';

void main() {
  final dio = Dio();

  test('Validation success', () async {
    final response =
        await dio.get('https://vrchat.com/api/1/config').validate();
    expect(response, isA<SuccessResponse>());
  });

  test('Validation failure', () async {
    final response =
        await dio.get('https://vrchat.com/api/2/config').validate();
    expect(response, isA<ErrorResponse>());
  });

  test('Transform success', () async {
    final response = await dio
        .get('https://vrchat.com/api/1/config')
        .validate<String>(transform: (data) => data['apiKey']);
    expect(response, isA<SuccessResponse>());
  });

  test('Transform failure', () async {
    final response = await dio
        .get('https://vrchat.com/api/1/config')
        .validate<String>(transform: (data) => data['invalid']);
    expect(response, isA<ErrorResponse>());
  });
}
