import 'package:exam5/features/videos/presentation/providers/providers.dart';
import 'package:exam5/features/videos/presentation/widgets/date_down_widget.dart';
import 'package:exam5/features/videos/presentation/widgets/error_widget.dart';
import 'package:exam5/features/videos/presentation/widgets/video_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:exam5/features/videos/domain/entities/video_entity.dart';
import 'package:exam5/core/extensions/youtube_url_extension.dart';
import 'package:exam5/core/enums/video_status.dart';

class VideoListTile extends ConsumerWidget {
  final VideoEntity video;
  final bool isCurrentVideo;
  final VoidCallback? onTap;

  const VideoListTile({
    super.key,
    required this.video,
    this.isCurrentVideo = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusAsync = ref.watch(videoStatusProvider(video));
    final logicAsync = ref.watch(videoLogicProvider);

    return statusAsync.when(
      data: (status) {
        return FutureBuilder<bool>(
          future: logicAsync.when(
            data: (logic) async {
              final allVideos = await ref.watch(videoListProvider.future);
              return logic.canWatchVideo(video.id, allVideos);
            },
            error: (e, _) => null,
            loading: () => null,
          ),
          builder: (context, snapshot) {
            final canWatch = snapshot.data ?? false;

            return Opacity(
              opacity: status == VideoStatus.korilmadi ? 0.6 : 1.0,
              child: ListTile(
                onTap: canWatch && status != VideoStatus.korilmadi
                    ? onTap
                    : null,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                tileColor: isCurrentVideo
                    ? Colors.blue.withValues(alpha: 0.1)
                    : Colors.transparent,
                leading: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        video.videoUrl.youtubeThumbnail,
                        width: 100,
                        height: 70,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 100,
                          height: 70,
                          color: Colors.grey.shade800,
                          child: const Icon(
                            Icons.video_library,
                            color: Colors.white54,
                          ),
                        ),
                      ),
                    ),
                    if (status == VideoStatus.korilmadi)
                      Positioned.fill(
                        child: Container(
                          color: Colors.black.withValues(alpha: 0.4),
                          child: Center(
                            child: canWatch
                                ? const Icon(
                                    Icons.lock,
                                    color: Colors.white,
                                    size: 30,
                                  )
                                : FutureBuilder<Duration?>(
                                    future: logicAsync.when(
                                      data: (logic) async {
                                        final allVideos = await ref.watch(
                                          videoListProvider.future,
                                        );
                                        return logic.getWaitingTime(
                                          video.id,
                                          allVideos,
                                        );
                                      },
                                      error: (e, _) => null,
                                      loading: () => null,
                                    ),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData &&
                                          snapshot.data != null) {
                                        final remaining = snapshot.data!;
                                        final hours = remaining.inHours;
                                        final minutes = remaining.inMinutes
                                            .remainder(60);
                                        return DateDownWidget(
                                          hours: hours,
                                          minutes: minutes,
                                        );
                                      }
                                      return const Icon(
                                        Icons.lock,
                                        color: Colors.white,
                                        size: 30,
                                      );
                                    },
                                  ),
                          ),
                        ),
                      ),
                  ],
                ),
                title: Text(
                  video.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      video.topic,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      error: (error, stackTrace) => VideoErrorWidget(error: error.toString()),
      loading: () => const VideoLoadingWidget(),
    );
  }
}
