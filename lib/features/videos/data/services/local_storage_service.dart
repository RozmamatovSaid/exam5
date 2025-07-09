import 'dart:convert';
import 'package:exam5/core/enums/video_status.dart';
import 'package:exam5/features/videos/data/models/video_progress_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String _videoProgressKey = 'video_progress';

  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  Future<List<VideoProgressModel>> getAllVideoProgress() async {
    final jsonString = _prefs.get(_videoProgressKey);
    if (jsonString == null) return [];

    final List<dynamic> jsonList = json.decode(jsonString.toString());

    return jsonList.map((json) => VideoProgressModel.fromJson(json)).toList();
  }

  Future<VideoProgressModel?> getOneVideoProgress(String videoId) async {
    final allProgress = await getAllVideoProgress();
    try {
      return allProgress.firstWhere((element) => element.videoId == videoId);
    } catch (e) {
      return null;
    }
  }

  Future<void> saveVideoProgress(VideoProgressModel model) async {
    final allProgress = await getAllVideoProgress();

    final index = allProgress.indexWhere(
      (element) => element.videoId == model.videoId,
    );

    if (index != -1) {
      allProgress[index] = model;
    } else {
      allProgress.add(model);
    }
    final jsonString = json.encode(allProgress.map((e) => e.toJson()).toList());
    await _prefs.setString(_videoProgressKey, jsonString);
  }

  Future<void> videoFinished(String videoId) async {
    final now = DateTime.now();
    final existingProgress = await getOneVideoProgress(videoId);

    final updateProgress = VideoProgressModel(
      videoId: videoId,
      status: VideoStatus.korildi,
      finishedAt: now,
      watchedAt: existingProgress?.watchedAt ?? now,
    );
    await saveVideoProgress(updateProgress);
    print(
      "-----------------------videoFinished: Video $videoId set to korildi at $now",
    );
  }

  Future<void> videoWatching(String videoId) async {
    final existingProgress = await getOneVideoProgress(videoId);

    final updateProgress = VideoProgressModel(
      videoId: videoId,
      status: VideoStatus.korilyapti,
      finishedAt: existingProgress?.finishedAt,
      watchedAt: existingProgress?.watchedAt ?? DateTime.now(),
    );
    await saveVideoProgress(updateProgress);
    print(
      "------------------------videoWatching: Video $videoId set to korilyapti at ${DateTime.now()}",
    );
  }

  Future<void> clearAllProgress() async {
    await _prefs.remove(_videoProgressKey);
    print(
      "-------------------------clearAllProgress: All video progress cleared",
    );
  }
}
