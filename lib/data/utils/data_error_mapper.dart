import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import '../datasources/remote_cv_datasource.dart';

class DataError {
  final String message;
  final String? code;
  final int? statusCode;

  DataError(this.message, {this.code, this.statusCode});

  @override
  String toString() => message;
}

class DataErrorMapper {
  static String _getCurrentLanguage() {
    try {
      return ui.PlatformDispatcher.instance.locale.languageCode;
    } catch (_) {
      return 'en';
    }
  }

  static DataError map(Object error) {
    final isId = _getCurrentLanguage() == 'id';

    if (error is ApiException) {
      final errorCode = error.errorCode;
      if (errorCode == 'EMAIL_NOT_VERIFIED') {
        return DataError(
          isId
              ? 'Silakan verifikasi email Anda terlebih dahulu untuk menggunakan fitur ini.'
              : 'Please verify your email address first to use this feature.',
          code: 'email_not_verified',
          statusCode: error.statusCode,
        );
      }
      if (error.statusCode == 401) {
        return DataError(
          isId
              ? 'Sesi Anda telah berakhir. Silakan masuk kembali.'
              : 'Your session has expired. Please log in again.',
          code: 'unauthorized',
          statusCode: 401,
        );
      }
      if (error.statusCode == 429) {
        return DataError(
          isId
              ? 'Terlalu banyak permintaan. Silakan tunggu beberapa saat dan coba lagi.'
              : 'Too many requests. Please wait a moment and try again.',
          code: 'rate_limited',
          statusCode: 429,
        );
      }
      return DataError(
        error.errorMessage,
        code: errorCode ?? 'api_error',
        statusCode: error.statusCode,
      );
    } else if (error is http.ClientException) {
      return DataError(
        isId
            ? 'Kesalahan jaringan: Periksa koneksi internet Anda.'
            : 'Network error: Check your internet connection.',
        code: 'network_error',
      );
    } else if (error is TimeoutException) {
      return DataError(
        isId
            ? 'Koneksi timeout. Silakan coba lagi.'
            : 'Connection timed out. Please try again.',
        code: 'timeout',
      );
    } else if (error is SocketException) {
      return DataError(
        isId
            ? 'Server tidak dapat dijangkau. Silakan coba lagi nanti.'
            : 'Server unreachable. Please try again later.',
        code: 'server_unreachable',
      );
    } else if (error is FirebaseAuthException) {
      String message;
      switch (error.code) {
        case 'user-not-found':
          message = isId
              ? 'Email tidak terdaftar.'
              : 'No user found for that email.';
          break;
        case 'wrong-password':
          message = isId ? 'Password salah.' : 'Wrong password provided.';
          break;
        case 'too-many-requests':
          message = isId
              ? 'Terlalu banyak percobaan masuk. Silakan coba lagi nanti.'
              : 'Too many login attempts. Please try again later.';
          break;
        case 'email-already-in-use':
          message = isId
              ? 'Email sudah digunakan oleh akun lain.'
              : 'The email address is already in use by another account.';
          break;
        case 'invalid-email':
          message = isId
              ? 'Format email tidak valid.'
              : 'The email address is badly formatted.';
          break;
        case 'weak-password':
          message = isId
              ? 'Sandi minimal harus terdiri dari 6 karakter.'
              : 'The password must be at least 6 characters.';
          break;
        case 'network-request-failed':
          message = isId
              ? 'Permintaan jaringan gagal. Silakan periksa koneksi Anda.'
              : 'Network request failed. Please check your connection.';
          break;
        default:
          message =
              error.message ??
              (isId ? 'Autentikasi gagal.' : 'Authentication failed.');
      }
      return DataError(message, code: error.code);
    } else if (error is FormatException) {
      return DataError(
        isId
            ? 'Data yang diterima dari server tidak valid.'
            : 'Invalid data received from server.',
        code: 'parse_error',
      );
    }

    return DataError(error.toString(), code: 'unknown_error');
  }
}
