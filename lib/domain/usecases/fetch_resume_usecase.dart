import '../entities/resume_entity.dart';
import '../repositories/resume_repository.dart';

class FetchResumeUseCase {
  final ResumeRepository repository;

  FetchResumeUseCase(this.repository);

  Future<ResumeEntity> call(String name) async {
    return await repository.getResume(name);
  }
}
