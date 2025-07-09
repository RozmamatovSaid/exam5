import 'package:exam5/core/enums/video_status.dart';
import 'package:exam5/features/videos/domain/entities/video_progress_entitiy.dart';

class VideoProgressModel extends VideoProgressEntity {
  const VideoProgressModel({
    required super.videoId,
    required super.status,
    super.finishedAt,
    super.watchedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'videoId': videoId,
      'status': videoStatusToString(status),
      'finishedAt': finishedAt?.toIso8601String(),
      'watchedAt': watchedAt?.toIso8601String(),
    };
  }

  factory VideoProgressModel.fromJson(Map<String, dynamic> json) {
    return VideoProgressModel(
      videoId: json['videoId'] ?? '',
      status: videoStatusFromString(json['status'] ?? 'korilmadi'),
      finishedAt: json['finishedAt'] != null
          ? DateTime.parse(json['finishedAt'])
          : null,
      watchedAt: json['watchedAt'] != null
          ? DateTime.parse(json['watchedAt'])
          : null,
    );
  }
}
