import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class E2EEInterceptor extends Interceptor {
  // Use a 32-character string for AES-256 key
  static const String _sharedKey = 'LinguAI-SuperSecretKey-32Bytes!!';
  
  // 16-byte Initialization Vector
  static final _iv = encrypt.IV.fromUtf8('LinguAI_IV_16byt'); 

  late final encrypt.Encrypter _encrypter;

  E2EEInterceptor() {
    final key = encrypt.Key.fromUtf8(_sharedKey);
    _encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Only encrypt POST/PUT/PATCH bodies
    if (['POST', 'PUT', 'PATCH'].contains(options.method.toUpperCase())) {
      if (options.data != null && options.data is Map<String, dynamic>) {
        try {
          final jsonString = jsonEncode(options.data);
          final encrypted = _encrypter.encrypt(jsonString, iv: _iv);
          
          // Replace raw data with encrypted payload
          options.data = {
            'encryptedPayload': encrypted.base64,
          };
        } catch (e) {
          debugPrint('E2EE Encryption Failed: $e');
        }
      }
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.data != null && response.data is Map<String, dynamic>) {
      final Map<String, dynamic> data = response.data;
      if (data.containsKey('encryptedPayload')) {
        try {
          final encryptedBase64 = data['encryptedPayload'] as String;
          final decryptedJsonString = _encrypter.decrypt64(encryptedBase64, iv: _iv);
          response.data = jsonDecode(decryptedJsonString);
        } catch (e) {
          debugPrint('E2EE Decryption Failed: $e');
        }
      }
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.data != null && err.response?.data is Map<String, dynamic>) {
      final Map<String, dynamic> data = err.response!.data;
      if (data.containsKey('encryptedPayload')) {
        try {
          final encryptedBase64 = data['encryptedPayload'] as String;
          final decryptedJsonString = _encrypter.decrypt64(encryptedBase64, iv: _iv);
          err.response!.data = jsonDecode(decryptedJsonString);
        } catch (e) {
          debugPrint('E2EE Decryption Failed in onError: $e');
        }
      }
    }
    super.onError(err, handler);
  }
}
