import 'package:dio/dio.dart';
import '../storage/token_storage.dart';

class AuthInterceptor extends Interceptor {
  final TokenStorage _tokenStorage;
  final Dio _originalDio;

  AuthInterceptor(this._tokenStorage, this._originalDio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final jwt = _tokenStorage.jwt;
    if (jwt != null) {
      options.headers['Authorization'] = 'Bearer $jwt';
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final refreshToken = await _tokenStorage.refreshToken;
      if (refreshToken != null) {
        try {
          // Use a new Dio instance to avoid interceptor loops
          final refreshDio = Dio(BaseOptions(baseUrl: _originalDio.options.baseUrl));
          final response = await refreshDio.post('/auth/refresh-token', data: {
            'token': refreshToken,
          });
          
          final newJwt = response.data['token'];
          
          await _tokenStorage.saveTokens(jwt: newJwt, refreshToken: refreshToken);
          
          // Retry original request
          err.requestOptions.headers['Authorization'] = 'Bearer $newJwt';
          
          final retryDio = Dio(_originalDio.options);
          final retryResponse = await retryDio.fetch(err.requestOptions);
          return handler.resolve(retryResponse);
        } catch (e) {
          await _tokenStorage.clearTokens();
        }
      } else {
        await _tokenStorage.clearTokens();
      }
    }
    return handler.next(err);
  }
}

