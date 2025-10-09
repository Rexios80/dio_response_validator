import 'package:dio/dio.dart';
import 'package:dio_response_validator/dio_response_validator.dart';
import 'package:test/test.dart';

void main() {
  final dio = Dio();

  test('Validation success', () async {
    final response = await dio
        .get('https://jsonplaceholder.typicode.com/todos/1')
        .validate();
    expect(response, isA<ValidResponse>());
  });

  test('Validation failure', () async {
    final response = await dio
        .get('https://jsonplaceholder.typicode.com/todos/0')
        .validate();
    expect(response, isA<InvalidResponse>());
    expect((response as InvalidResponse).error, isNot(isA<String>()));
  });
  
  test('Transform DioException', () async {
    final response = await dio
        .get('https://jsonplaceholder.typicode.com/todos/0')
        .validate()
        .transform(
          transformDioException: (error) =>
              error.response?.data['message'] ?? 'Unknown error',
        );
    expect((response as InvalidResponse).error, isA<String>());
  });

  test('Transform success', () async {
    final response = await dio
        .get('https://jsonplaceholder.typicode.com/todos/1')
        .validate()
        .transform<String>(transform: (data) => data['title']);
    expect(response, isA<ValidResponse>());
  });

  test('Transform failure', () async {
    final response = await dio
        .get('https://jsonplaceholder.typicode.com/todos/1')
        .validate()
        .transform<String>(transform: (data) => data['invalid']);
    expect(response, isA<InvalidResponse>());
  });
}
