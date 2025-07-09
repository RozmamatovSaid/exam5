import 'package:exam5/features/videos/domain/entities/video_entity.dart';

abstract class VideoRepository {
  Future<List<VideoEntity>> getAllVideos();
  Stream<List<VideoEntity>> watchVideos();
}
