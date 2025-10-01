import '../../domain/entities/resume_entity.dart';
import '../../domain/repositories/resume_repository.dart';
import '../datasources/remote_datasource.dart';

class ResumeRepositoryImpl implements ResumeRepository {
  final RemoteDataSource remote;

  ResumeRepositoryImpl(this.remote);

  @override
  Future<ResumeEntity> getResume(String name) async {
    final model = await remote.getResume(name);
    return model.toEntity();
  }
}
