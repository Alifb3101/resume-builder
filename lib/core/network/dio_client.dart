import 'package:dio/dio.dart';

class DioClient {
  final Dio dio;
  DioClient(String baseUrl)
      : dio = Dio(BaseOptions(baseUrl: baseUrl));
}
