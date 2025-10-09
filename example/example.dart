import 'package:dio/dio.dart';
import 'package:dio_response_validator/dio_response_validator.dart';

void main() async {
  final dio = Dio();

  final successResponse = await dio
      .get('https://jsonplaceholder.typicode.com/todos/1')
      .validate()
      .transform<String>(transform: (data) => data['title']);

  // Prints the api key
  printResponse(successResponse);

  final failureResponse =
      await dio.get('https://jsonplaceholder.typicode.com/todos/0').validate();

  // Prints a 404 error
  printResponse(failureResponse);
}

void printResponse(ValidatedResponse response) {
  switch (response) {
    case ValidResponse(data: final data):
      print(data);
    case InvalidResponse(error: final error):
      print(error);
  }
}
