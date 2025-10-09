An extension on Dio response futures to perform validation and data transformation

## Features

- Validate responses from Dio without using try/catch blocks everywhere
- Easily transform responses from Dio into your own data models
- Handles transformation errors

## Usage

<!-- embedme example/example.dart -->

```dart
import 'package:dio/dio.dart';
import 'package:dio_response_validator/dio_response_validator.dart';

void main() async {
  final dio = Dio();

  final successResponse = await dio
      .get('https://jsonplaceholder.typicode.com/todos/1')
      .validate()
      .transform<String>(data: (data) => data['title']);

  // Prints the api key
  printResponse(successResponse);

  final failureResponse =
      await dio.get('https://jsonplaceholder.typicode.com/todos/0').validate();

  // Prints a 404 error
  printResponse(failureResponse);
}

void printResponse(ValidatedResponse response) {
  final (success, failure) = response;
  if (success != null) {
    print(success.data);
  } else if (failure != null) {
    print(failure);
  } else {
    throw StateError('This should never happen');
  }
}

```

## Additional information

Pull requests welcome
