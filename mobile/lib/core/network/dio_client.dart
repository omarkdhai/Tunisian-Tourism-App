import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DioClient {
  final Dio _dio;
  final FlutterSecureStorage _storage;

  // Android emulator maps host to 10.0.2.2; web/iOS/desktop use localhost
  static String get _baseUrl => kIsWeb
      ? 'http://localhost:8080/api'
      : 'http://10.0.2.2:8080/api'; 

  DioClient(this._storage) : _dio = Dio(BaseOptions(
    baseUrl: _baseUrl,
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
    responseType: ResponseType.json,
  )) {
    _dio.interceptors.add(_authInterceptor());
    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
    ));
  }

  Dio get dio => _dio;

  Interceptor _authInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Exclude specific public routes from attaching bearer tokens (e.g. login)
        if (!options.path.contains('/login') && !options.path.contains('/register')) {
          final token = await _storage.read(key: 'jwt_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) async {
        // Handle 401 Unauthorized globally (e.g., token expired)
        if (e.response?.statusCode == 401) {
          await _storage.delete(key: 'jwt_token');
          // In a real app with go_router, you'd trigger a router refresh or send an event to redirect to login
        }
        return handler.next(e);
      },
    );
  }
}
