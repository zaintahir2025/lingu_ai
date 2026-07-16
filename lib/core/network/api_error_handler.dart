import 'package:dio/dio.dart';

class ApiErrorHandler {
  static String handleMessage(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return 'Connection timed out. Please check your internet.';
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          if (statusCode == 400) return 'Invalid request. Please check your input.';
          if (statusCode == 401) return 'Unauthorized. Please log in again.';
          if (statusCode == 403) return 'You do not have permission to perform this action.';
          if (statusCode == 404) return 'Resource not found.';
          if (statusCode == 500) return 'Server error. Please try again later.';
          return 'Received invalid response from the server.';
        case DioExceptionType.cancel:
          return 'Request to API server was cancelled';
        case DioExceptionType.connectionError:
          return 'No internet connection.';
        default:
          return 'An unexpected network error occurred.';
      }
    }
    return 'An unexpected error occurred: ${error.toString()}';
  }
}
