import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exam5/core/enums/video_status.dart';
import 'package:exam5/features/videos/data/services/local_storage_service.dart';
import 'package:exam5/features/videos/data/services/video_logic_service.dart';
import 'package:exam5/features/videos/domain/entities/video_entity.dart';
import 'package:exam5/features/videos/domain/usecases/watch_videos_usecase.dart';
import 'package:exam5/features/videos/videos.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final videoRemoteDatasourceProvider = Provider<VideoRemoteDatasource>((ref) {
  return VideoRemoteDatasourceImpl(FirebaseFirestore.instance);
});

final videoRepositoryProvider = Provider<VideoRepository>((ref) {
  final remoteDatasource = ref.read(videoRemoteDatasourceProvider);
  return VideoRepositoryImpl(remoteDatasource);
});

final watchVideosUseCaseProvider = Provider<WatchVideosUseCase>((ref) {
  final repository = ref.read(videoRepositoryProvider);
  return WatchVideosUseCase(repository);
});

final videoListProvider = StreamProvider<List<VideoEntity>>((ref) {
  final useCase = ref.read(watchVideosUseCaseProvider);
  return useCase.call();
});

final localStorageServiceProvider = FutureProvider<LocalStorageService>((
  ref,
) async {
  final prefs = await SharedPreferences.getInstance();
  return LocalStorageService(prefs);
});
final videoLogicProvider = FutureProvider<VideoLogicService>((ref) async {
  final storage = await ref.watch(localStorageServiceProvider.future);
  return VideoLogicService(storage);
});

final videoStatusProvider = FutureProvider.family<VideoStatus, VideoEntity>((
  ref,
  video,
) async {
  final logic = await ref.watch(videoLogicProvider.future);
  final allVideos = await ref.watch(videoListProvider.future);
  return logic.getVideoStatus(video.id, allVideos);
});

final currentVideoProvider = StateProvider<VideoEntity?>((ref) => null);
