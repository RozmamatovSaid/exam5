import 'package:exam5/features/videos/domain/entities/video_entity.dart';
import 'package:exam5/features/videos/domain/repositories/video_repository.dart';

class WatchVideosUseCase {
  final VideoRepository repository;

  WatchVideosUseCase(this.repository);

  Stream<List<VideoEntity>> call() {
    return repository.watchVideos();
  }
}
