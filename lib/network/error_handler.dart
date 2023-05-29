import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter/services.dart';

import '../extensions/extensions.dart';

enum CustomErrorCode {
  noError(0),
  hasError(1);

  final int code;
  const CustomErrorCode(this.code);
}

// 401, 403, 404, 405, 422, 500(default)

AppError? _appErrorMapping(String? errorCode, {String? description}) {
  switch (errorCode) {
    case '401':
      return AppErrorUserUnauthenticated(message: description);
    case '429':
      return const AppErrorTooManyRequests();
    case '503':
      return const AppErrorServerDown();
    case 'sign_in_failed':
      return const AppErrorFingerPrintException();
    default:
      return null;
  }
}

abstract class AppError {
  final String title;
  final String description;
  const AppError({
    required this.title,
    required this.description,
  });

  factory AppError.fromError(dynamic error) {
    log('app error: $error');

    if (error is DioError) {
      final statusCode = error.response?.statusCode;
      final statusMessage = error.response?.statusMessage;
      final errorMessage = error.response?.data['error_message'].toString();

      switch (error.type) {
        case DioErrorType.unknown:
          return const AppErrorUnknown();
        case DioErrorType.badResponse:
          return AppErrorServerCustom(errorMessage: (error.response?.data['error_message']).toString());
        default:
          log('AppError: ${error.toString()}');

          final errorCode = statusCode?.toString().toLowerCase().trim().replaceAll(' ', '-');
          final errorWidget = _appErrorMapping(errorCode, description: errorMessage);
          return errorWidget ??
              AppErrorCode(
                errorCode: statusCode.orZero().toString(),
                errorMessage: statusMessage.orEmpty(),
              );
      }
    } else if (error is PlatformException) {
      final code = error.code;
      final errorMapKey = code.toString().toLowerCase().trim().replaceAll(' ', '-');
      return _appErrorMapping(errorMapKey) ?? const AppErrorUnknown();
    } else if (error is AppErrorTooManyRequests) {
      return error;
    }
    return const AppErrorUnknown();
  }
}

@immutable
class AppErrorFingerPrintException extends AppError {
  const AppErrorFingerPrintException({
    super.title = 'Google Sign In Error!',
    super.description = 'Error Code: 50010',
  });
}

@immutable
class AppErrorNoInternetConnection extends AppError {
  const AppErrorNoInternetConnection()
      : super(
          title: 'No internet connection!',
          description: 'Please check connection and try again.',
        );
}

@immutable
class AppErrorUnknown extends AppError {
  const AppErrorUnknown()
      : super(
          title: 'Unknown Error',
          description: 'Unknown Error',
        );
}

@immutable
class AppErrorCode extends AppError {
  const AppErrorCode({
    required String errorCode,
    required String errorMessage,
  }) : super(
          title: errorCode,
          description: errorMessage,
        );
}

@immutable
class AppErrorServerCustom extends AppError {
  const AppErrorServerCustom({
    required String errorMessage,
  }) : super(
          title: 'Error!',
          description: errorMessage,
        );
}

@immutable
class AppErrorTooManyRequests extends AppError {
  /// implement according to errors later
  const AppErrorTooManyRequests()
      : super(
          title: 'Too Many Requests!',
          description: 'Please wait a few moment before requesting again.',
        );
}

class AppErrorUserUnauthenticated extends AppError {
  final String? message;
  const AppErrorUserUnauthenticated({
    super.title = 'Unauthorized Request!',
    this.message,
  }) : super(description: message ?? 'Please try again.');
}

@immutable
class AppErrorGoogleAccessTokenNotFound extends AppError {
  /// implement according to errors later
  const AppErrorGoogleAccessTokenNotFound()
      : super(
          title: 'No Google Account Found!',
          description: 'Please check your Google account and try again.',
        );
}

@immutable
class AppErrorAppleAccessTokenNotFound extends AppError {
  /// implement according to errors later
  const AppErrorAppleAccessTokenNotFound()
      : super(
          title: 'No Apple Account Found!',
          description: 'Please check your Apple account and try again.',
        );
}

@immutable
class AppErrorServerDown extends AppError {
  const AppErrorServerDown({
    super.title = 'Maintenance Break!',
    super.description = 'We are currently working to update our system. Thank you for your patience.',
  });
}
