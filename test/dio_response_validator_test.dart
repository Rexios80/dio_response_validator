import 'package:dio/dio.dart';
import 'package:dio_response_validator/dio_response_validator.dart';
import 'package:test/test.dart';

void main() {
  final dio = Dio(
    BaseOptions(
      headers: {
        // For some reason a properly formatter user-agent wasn't working
        // So here's a browser user-agent
        'User-Agent':
            'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.0 Safari/605.1.15',
      },
    ),
  );

  test('Validation success', () async {
    final (success, failure) =
        await dio.get('https://vrchat.com/api/1/config').validate();
    expect(success, isNotNull);
  });

  test('Validation failure', () async {
    final (success, failure) =
        await dio.get('https://vrchat.com/api/2/config').validate();
    expect(failure, isNotNull);
    expect(failure!.error, isNot(isA<String>()));
  });

  test('Transform DioException', () async {
    final (success, failure) =
        await dio.get('https://vrchat.com/api/2/config').validate().transform(
              transformDioException: (error) =>
                  error.response?.data['message'] ?? 'Unknown error',
            );
    expect(failure!.error, isA<String>());
  });

  test('Transform success', () async {
    final (success, failure) = await dio
        .get('https://vrchat.com/api/1/config')
        .validate()
        .transform(transform: (data) => data['defaultAvatar']);
    expect(success, isNotNull);
  });

  test('Transform failure', () async {
    final (success, failure) = await dio
        .get('https://vrchat.com/api/1/config')
        .validate()
        .transform(transform: (data) => data['invalid'] as String);
    expect(failure, isNotNull);
  });
}
