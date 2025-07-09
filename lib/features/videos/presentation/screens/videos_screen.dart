import 'package:exam5/features/videos/presentation/providers/providers.dart';
import 'package:exam5/features/videos/presentation/screens/play_video.dart';
import 'package:exam5/features/videos/presentation/widgets/error_widget.dart';
import 'package:exam5/features/videos/presentation/widgets/video_list_tile.dart';
import 'package:exam5/features/videos/presentation/widgets/video_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VideosScreen extends ConsumerWidget {
  const VideosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoAsync = ref.watch(videoListProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        forceMaterialTransparency: true,
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          "Premium video darsliklar",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Container(
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
        child: SafeArea(
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
                      SizedBox(height: 8),
                      Text(
                        'Hozircha hech qanday video mavjud emas',
                        style: TextStyle(color: Colors.white54, fontSize: 14),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(videoListProvider);
                },
                backgroundColor: const Color(0xFF1B223A),
                color: Colors.white,
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 31,
                  ),
                  itemCount: videos.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final video = videos[index];
                    return VideoListTile(
                      video: video,
                      onTap: () => _showVideoPlayer(context, video, ref),
                    );
                  },
                ),
              );
            },
            error: (error, stackTrace) {
              debugPrint('Video list error: $error');
              debugPrint('Stack trace: $stackTrace');
              return VideoErrorWidget(error: error.toString());
            },
            loading: () => const VideoLoadingWidget(),
          ),
        ),
      ),
    );
  }

  void _showVideoPlayer(BuildContext context, video, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PlayVideo(video: video),
    );
  }
}
