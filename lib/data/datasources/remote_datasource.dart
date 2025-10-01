import 'package:dio/dio.dart';
import '../models/resume_model.dart';

abstract class RemoteDataSource {
  Future<ResumeModel> getResume(String name);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final Dio dio;

  RemoteDataSourceImpl(this.dio);

  @override
  Future<ResumeModel> getResume(String name) async {
    final response = await dio.get(
      '/resume',
      queryParameters: {"name": name},
    );
    if (response.statusCode == 200) {
      return ResumeModel.fromMap(response.data);
    } else {
      throw Exception('Failed to fetch resume');
    }
  }
}
