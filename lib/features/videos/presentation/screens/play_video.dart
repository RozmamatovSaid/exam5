import 'package:exam5/features/videos/domain/entities/video_entity.dart';
import 'package:exam5/features/videos/presentation/providers/providers.dart';
import 'package:exam5/features/videos/presentation/widgets/error_widget.dart';
import 'package:exam5/features/videos/presentation/widgets/video_list_tile.dart';
import 'package:exam5/features/videos/presentation/widgets/video_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PlayVideo extends ConsumerStatefulWidget {
  final VideoEntity video;

  const PlayVideo({super.key, required this.video});

  @override
  ConsumerState<PlayVideo> createState() => _PlayVideoState();
}

class _PlayVideoState extends ConsumerState<PlayVideo> {
  YoutubePlayerController? _controller;
  String? _currentVideoId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(currentVideoProvider.notifier).state = widget.video;
      ref.read(localStorageServiceProvider.future).then((storage) {
        storage.videoWatching(widget.video.id);
      });
    });
  }

  void _updateController(VideoEntity video) {
    final videoId = YoutubePlayer.convertUrlToId(video.videoUrl);

    if (videoId != null && videoId != _currentVideoId) {
      _controller?.dispose();
      _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(autoPlay: true, mute: false),
      );
      _currentVideoId = videoId;

      _controller!.addListener(() {
        if (_controller!.value.playerState == PlayerState.ended) {
          ref.read(videoLogicProvider.future).then((logic) async {
            final allVideos = await ref.watch(videoListProvider.future);
            await logic.finishedVideo(widget.video.id, allVideos);
          });
        }
      });
    }
  }

  void _changeVideo(VideoEntity newVideo) {
    final currentVideo = ref.read(currentVideoProvider);
    if (currentVideo?.id != newVideo.id) {
      ref.read(currentVideoProvider.notifier).state = newVideo;
      ref.read(localStorageServiceProvider.future).then((storage) {
        storage.videoWatching(newVideo.id);
      });
    }
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final videoAsync = ref.watch(videoListProvider);
    final currentVideo = ref.watch(currentVideoProvider);

    if (currentVideo != null) {
      _updateController(currentVideo);
    }

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1B223A),
            Color(0xFF151825),
            Color(0xFF151825),
            Color(0xFF151825),
            Color(0xFF151825),
            Color(0xFF1B223A),
          ],
        ),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              if (_controller != null && currentVideo != null)
                YoutubePlayer(
                  key: ValueKey(currentVideo.id),
                  controller: _controller!,
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: Colors.red,
                  controlsTimeOut: const Duration(seconds: 3),
                )
              else
                Container(
                  height: 200,
                  color: Colors.black,
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.red),
                  ),
                ),
              Positioned(
                left: 10,
                top: 10,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          if (currentVideo != null)
            Container(
              padding: const EdgeInsets.only(right: 31, left: 31, top: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentVideo.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currentVideo.topic,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 24),
                  const Divider(height: 2, color: Color(0xFF262B3D)),
                  const SizedBox(height: 14),
                  const Text(
                    "Boshqa videodarsliklar",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 170,
                    height: 2,
                    color: const Color(0xFF0085FF),
                  ),
                ],
              ),
            ),
          Expanded(
            child: videoAsync.when(
              data: (videos) {
                if (videos.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.video_library_outlined,
                          size: 64,
                          color: Colors.white54,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Video topilmadi',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 31,
                  ),
                  itemCount: videos.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final video = videos[index];
                    final isCurrentVideo = currentVideo?.id == video.id;
                    return VideoListTile(
                      video: video,
                      isCurrentVideo: isCurrentVideo,
                      onTap: () => _changeVideo(video),
                    );
                  },
                );
              },
              error: (error, stackTrace) {
                debugPrint('Video list error: $error');
                return VideoErrorWidget(error: error.toString());
              },
              loading: () => const VideoLoadingWidget(),
            ),
          ),
        ],
      ),
    );
  }
}
