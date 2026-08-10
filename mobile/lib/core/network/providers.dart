import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dio_client.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

final dioClientProvider = Provider<Dio>((ref) {
  final storage = ref.watch(secureStorageProvider);
  return DioClient(storage).dio;
});
