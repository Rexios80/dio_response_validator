import 'package:dio/dio.dart';
import 'package:dio_response_validator/dio_response_validator.dart';

void main() async {
  final dio = Dio();

  final successResponse =
      await dio.get('https://vrchat.com/api/1/config').validate();
  printResponse(successResponse);

  final errorResponse =
      await dio.get('https://vrchat.com/api/2/config').validate();
  printResponse(errorResponse);
}

void printResponse(ValidatedResponse response) {
  if (response.success != null) {
    print(response.success!.data);
  } else {
    print(response.error!.validationError);
  }
}
