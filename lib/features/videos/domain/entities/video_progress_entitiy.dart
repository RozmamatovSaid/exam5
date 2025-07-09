import 'package:exam5/core/enums/video_status.dart';

class VideoProgressEntity {
  final String videoId;
  final VideoStatus status;
  final DateTime? finishedAt;
  final DateTime? watchedAt;

  const VideoProgressEntity({
    required this.videoId,
    required this.status,
    this.finishedAt,
    this.watchedAt,
  });

  VideoProgressEntity copyWith({
    String? videoId,
    VideoStatus? status,
    DateTime? finishedAt,
    DateTime? watchedAt,
  }) {
    return VideoProgressEntity(
      videoId: videoId ?? this.videoId,
      status: status ?? this.status,
      finishedAt: finishedAt ?? this.finishedAt,
      watchedAt: watchedAt ?? this.watchedAt,
    );
  }
}
