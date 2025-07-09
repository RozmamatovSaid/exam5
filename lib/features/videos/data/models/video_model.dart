import 'package:exam5/features/videos/domain/entities/video_entity.dart';

class VideoModel extends VideoEntity {
  const VideoModel({
    required super.id,
    required super.videoUrl,
    required super.title,
    required super.topic,
    required super.order,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json, String docId) {
    return VideoModel(
      id: docId,
      videoUrl: json['videoUrl'] ?? '',
      title: json['title'] ?? '',
      topic: json['topic'] ?? '',
      order: json['order'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'videoUrl': videoUrl,
      'title': title,
      'topic': topic,
      'order': order,
    };
  }
}
