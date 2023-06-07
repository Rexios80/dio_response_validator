## 0.2.3
- Removes deprecated use of `DioError`

## 0.2.2
- Upgrades dio to 5.0.0

## 0.2.1
- Adds `transformDioError` field to `validate`

## 0.2.0
- Adds support for the `diox` package through a new `diox_response_validator` package
- `validate` call now takes two type arguments
- Renames `SuccessResponse` to `ValidResponse`, and `ErrorResponse` to `InvalidResponse`
- `ValidResponse.response` is now properly typed
- Removes `ValidationError` class and adds those properties to the `InvalidResponse` class
- Renames `ValidatedResponse.error` to `ValidatedResponse.failure`

## 0.1.1
- Uses generic type on extension

## 0.1.0
- Initial release
