import 'package:exam5/features/videos/domain/entities/video_entity.dart';
import 'package:exam5/features/videos/domain/repositories/video_repository.dart';

class GetVideosUseCase {
  final VideoRepository repository;

  GetVideosUseCase(this.repository);

  Future<List<VideoEntity>> call() {
    return repository.getAllVideos();
  }
}