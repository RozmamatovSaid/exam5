import 'package:exam5/features/videos/data/models/video_model.dart';

abstract class VideoRemoteDatasource {
  Future<List<VideoModel>> getVideos();
  Stream<List<VideoModel>> watchVideos();
}
