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

  final successResponse =
      await dio.get('https://vrchat.com/api/1/config').validate(
            transform: (data) => data['apiKey'],
          );

  // Prints the api key
  printResponse(successResponse);

  final errorResponse =
      await dio.get('https://vrchat.com/api/2/config').validate();

  // Prints a 404 error
  printResponse(errorResponse);
}

void printResponse(ValidatedResponse response) {
  if (response.success != null) {
    print(response.success!.data);
  } else {
    print(response.error!.validationError);
  }
}

```

## Additional information

Pull requests welcome
