import 'package:exam5/core/enums/video_status.dart';
import 'package:exam5/features/videos/data/models/video_progress_model.dart';
import 'package:exam5/features/videos/data/services/local_storage_service.dart';
import 'package:exam5/features/videos/domain/entities/video_entity.dart';

class VideoLogicService {
  final LocalStorageService _localStorage;
  VideoLogicService(this._localStorage);

  //video korish mumkinmi
  Future<bool> canWatchVideo(
    String videoId,
    List<VideoEntity> allVideos,
  ) async {
    final video = allVideos.firstWhere((v) => v.id == videoId);
    final index = allVideos.indexOf(video);

    // 1-video pastyani ochiq turishi kerak
    if (index == 0) return true;

    final prevVideo = allVideos[index - 1];
    final prevProgress = await _localStorage.getOneVideoProgress(prevVideo.id);

    if (prevProgress == null || prevProgress.status != VideoStatus.korildi) {
      return false;
    }

    final finishedAt = prevProgress.finishedAt;
    if (finishedAt == null) return false;

    final diff = DateTime.now().difference(finishedAt);
    return diff.inHours >= 24;
  }

  // statuslar
  Future<VideoStatus> getVideoStatus(
    String videoId,
    List<VideoEntity> allVideos,
  ) async {
    final index = allVideos.indexWhere((v) => v.id == videoId);
    if (index == -1) return VideoStatus.korilmadi;

    if (index == 0) return VideoStatus.korilyapti;

    final prevVideo = allVideos[index - 1];
    final prevProgress = await _localStorage.getOneVideoProgress(prevVideo.id);

    if (prevProgress?.status == VideoStatus.korildi &&
        prevProgress?.finishedAt != null) {
      final diff = DateTime.now().difference(prevProgress!.finishedAt!);
      if (diff.inHours >= 24) {
        return VideoStatus.korilyapti;
      }
    }

    return VideoStatus.korilmadi;
  }

  // finished video uchun
  Future<void> finishedVideo(
    String videoId,
    List<VideoEntity> allVideos,
  ) async {
    final index = allVideos.indexWhere((v) => v.id == videoId);
    if (index == -1) return;

    await _localStorage.videoFinished(videoId);

    if (index + 1 < allVideos.length) {
      final nextVideo = allVideos[index + 1];
      final existing = await _localStorage.getOneVideoProgress(nextVideo.id);

      final model = VideoProgressModel(
        videoId: nextVideo.id,
        status: VideoStatus.korilyapti,
        watchedAt: DateTime.now(),
        finishedAt: existing?.finishedAt,
      );

      await _localStorage.saveVideoProgress(model);
    }
  }

  Future<Duration?> getWaitingTime(
    String videoId,
    List<VideoEntity> allVideos,
  ) async {
    final index = allVideos.indexWhere((v) => v.id == videoId);
    if (index <= 0) return null;

    final prevVideo = allVideos[index - 1];
    final prevProgress = await _localStorage.getOneVideoProgress(prevVideo.id);

    if (prevProgress?.finishedAt == null) return null;

    final diff = DateTime.now().difference(prevProgress!.finishedAt!);
    final remaining = Duration(hours: 24) - diff;
    return remaining.isNegative ? null : remaining;
  }
}
