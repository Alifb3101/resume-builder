import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/local/hive_service.dart';
import '../../data/datasources/remote_datasource.dart';
import '../../data/repositories/resume_repository_impl.dart';
import '../../domain/usecases/fetch_resume_usecase.dart';
import '../../domain/entities/resume_entity.dart';
import 'package:dio/dio.dart';

final hiveServiceProvider = Provider((ref) => HiveService());
final nameInputProvider = StateProvider<String>((ref) => 'aliasgar');
final summaryInputProvider = StateProvider<String>((ref) => 'Highly motivated software developer...');
final submittedNameProvider = StateProvider<String>((ref) => 'aliasgar');
final fontSizeProvider = StateNotifierProvider<FontSizeNotifier, double>((ref) {
  final hive = ref.watch(hiveServiceProvider);
  return FontSizeNotifier(hive);
});

class FontSizeNotifier extends StateNotifier<double> {
  final HiveService hive;
  FontSizeNotifier(this.hive) : super(hive.getFontSize());
  void setFontSize(double v) {
    state = v;
    hive.setFontSize(v);
  }
}

final fontColorProvider = StateNotifierProvider<FontColorNotifier, int>((ref) {
  final hive = ref.watch(hiveServiceProvider);
  return FontColorNotifier(hive);
});

class FontColorNotifier extends StateNotifier<int> {
  final HiveService hive;
  FontColorNotifier(this.hive) : super(hive.getFontColor());
  void setFontColor(int v) {
    state = v;
    hive.setFontColor(v);
  }
}
final AccentProvider = StateNotifierProvider<AccentNotifier, int>((ref) {
  final hive = ref.watch(hiveServiceProvider);
  return AccentNotifier(hive);
});


final bgColorProvider = StateNotifierProvider<BgColorNotifier, int>((ref) {
  final hive = ref.watch(hiveServiceProvider);
  return BgColorNotifier(hive);
});




class BgColorNotifier extends StateNotifier<int> {
  final HiveService hive;
  BgColorNotifier(this.hive) : super(hive.getBackgroundColor());
  void setBgColor(int v) {
    state = v;
    hive.setBackgroundColor(v);
  }
}

class AccentNotifier extends StateNotifier<int> {
  final HiveService hive;
  AccentNotifier(this.hive) : super(hive.getAccentColor());
  void setAccentColor(int v) {
    state = v;
    hive.setAccentColor(v);
  }
}

final dioProvider = Provider<Dio>((ref) => Dio(BaseOptions(baseUrl: 'https://expressjs-api-resume-random.onrender.com')));

final remoteDataSourceProvider = Provider<RemoteDataSourceImpl>((ref) => RemoteDataSourceImpl(ref.watch(dioProvider)));

final resumeRepositoryProvider = Provider<ResumeRepositoryImpl>((ref) => ResumeRepositoryImpl(ref.watch(remoteDataSourceProvider)));

final fetchResumeUseCaseProvider = Provider<FetchResumeUseCase>((ref) => FetchResumeUseCase(ref.watch(resumeRepositoryProvider)));

final resumeFutureProvider = FutureProvider.family<ResumeEntity, String>((ref, name) async {
  final uc = ref.watch(fetchResumeUseCaseProvider);
  return await uc(name);
});
