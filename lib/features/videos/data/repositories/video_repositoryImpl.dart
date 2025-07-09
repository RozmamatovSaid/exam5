import 'package:exam5/features/videos/domain/datasources/datasources.dart';
import 'package:exam5/features/videos/domain/entities/video_entity.dart';
import 'package:exam5/features/videos/domain/repositories/video_repository.dart';

class VideoRepositoryImpl implements VideoRepository {
  final VideoRemoteDatasource remoteDatasource;

  VideoRepositoryImpl(this.remoteDatasource);

  @override
  Future<List<VideoEntity>> getAllVideos() {
    return remoteDatasource.getVideos();
  }

  @override
  Stream<List<VideoEntity>> watchVideos() {
    return remoteDatasource.watchVideos();
  }
}