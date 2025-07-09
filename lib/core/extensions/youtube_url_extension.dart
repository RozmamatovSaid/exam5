extension YoutubeUrlExtension on String {
  String get youtubeThumbnail {
    String? videoId = _extractVideoId(this);
    if (videoId != null) {
      return 'https://img.youtube.com/vi/$videoId/mqdefault.jpg';
    }

    return 'https://via.placeholder.com/320x180.png?text=Video';
  }

  String? _extractVideoId(String url) {
    RegExp regExp = RegExp(
      r'(?:youtube\.com\/(?:[^\/\n\s]+\/\S+\/|(?:v|e(?:mbed)?)\/|\S*?[?&]v=)|youtu\.be\/)([a-zA-Z0-9_-]{11})',
      caseSensitive: false,
      multiLine: false,
    );

    Match? match = regExp.firstMatch(url);
    return match?.group(1);
  }
}
