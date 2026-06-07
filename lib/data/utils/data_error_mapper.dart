import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import '../datasources/remote_cv_datasource.dart';

class DataError {
  final String message;
  final String? code;

  DataError(this.message, {this.code});

  @override
  String toString() => message;
}

class DataErrorMapper {
  static DataError map(Object error) {
    if (error is ApiException) {
      final errorCode = error.errorCode;
      if (errorCode == 'EMAIL_NOT_VERIFIED') {
        return DataError(
          'Silakan verifikasi email Anda terlebih dahulu untuk menggunakan fitur ini.',
          code: 'email_not_verified',
        );
      }
      if (error.statusCode == 401) {
        return DataError(
          'Sesi Anda telah berakhir. Silakan masuk kembali.',
          code: 'unauthorized',
        );
      }
      return DataError(error.errorMessage, code: 'api_error');
    } else if (error is http.ClientException) {
      return DataError(
        'Network error: Check your internet connection.',
        code: 'network_error',
      );
    } else if (error is SocketException) {
      return DataError(
        'Server unreachable. Please try again later.',
        code: 'server_unreachable',
      );
    } else if (error is FirebaseAuthException) {
      return DataError(
        error.message ?? 'Authentication failed.',
        code: error.code,
      );
    } else if (error is FormatException) {
      return DataError(
        'Invalid data received from server.',
        code: 'parse_error',
      );
    }

    return DataError(error.toString(), code: 'unknown_error');
  }
}
