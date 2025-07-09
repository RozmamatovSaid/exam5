class VideoEntity {
  final String id;
  final String videoUrl;
  final String title;
  final String topic;
  final int order;

  const VideoEntity({
    required this.id,
    required this.videoUrl,
    required this.title,
    required this.topic,
    required this.order,
  });

  VideoEntity copyWith({
    String? id,
    String? videoUrl,
    String? title,
    String? topic,
    int? order,
  }) {
    return VideoEntity(
      id: id ?? this.id,
      videoUrl: videoUrl ?? this.videoUrl,
      title: title ?? this.title,
      topic: topic ?? this.topic,
      order: order ?? this.order,
    );
  }
}
