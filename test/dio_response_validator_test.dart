import 'package:dio/dio.dart';
import 'package:dio_response_validator/dio_response_validator.dart';
import 'package:test/test.dart';

void main() {
  final dio = Dio();

  test('Validation success', () async {
    final (success, failure) = await dio
        .get('https://jsonplaceholder.typicode.com/todos/1')
        .validate();
    expect(success, isNotNull);
  });

  test('Validation failure', () async {
    final (success, failure) = await dio
        .get('https://jsonplaceholder.typicode.com/todos/0')
        .validate();
    expect(failure, isNotNull);
    expect(failure!.error, isNot(isA<String>()));
  });

  test('Transform DioException', () async {
    final (success, failure) = await dio
        .get('https://jsonplaceholder.typicode.com/todos/0')
        .validate()
        .transform(
          transformDioException: (error) =>
              error.response?.data['message'] ?? 'Unknown error',
        );
    expect(failure!.error, isA<String>());
  });

  test('Transform success', () async {
    final (success, failure) = await dio
        .get('https://jsonplaceholder.typicode.com/todos/1')
        .validate()
        .transform(transform: (data) => data['defaultAvatar']);
    expect(success, isNotNull);
  });

  test('Transform failure', () async {
    final (success, failure) = await dio
        .get('https://jsonplaceholder.typicode.com/todos/1')
        .validate()
        .transform(transform: (data) => data['invalid'] as String);
    expect(failure, isNotNull);
  });
}
