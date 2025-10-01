import '../entities/resume_entity.dart';


abstract class ResumeRepository {
  Future<ResumeEntity> getResume(String name);
}
