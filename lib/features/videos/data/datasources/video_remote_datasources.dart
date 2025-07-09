import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exam5/features/videos/videos.dart';

class VideoRemoteDatasourceImpl implements VideoRemoteDatasource {
  final FirebaseFirestore firestore;

  VideoRemoteDatasourceImpl(this.firestore);

  @override
  Future<List<VideoModel>> getVideos() async {
    final snapshot = await firestore
        .collection('videos')
        .orderBy('order')
        .get();

    return snapshot.docs
        .map((doc) => VideoModel.fromJson(doc.data(), doc.id))
        .toList();
  }

  @override
  Stream<List<VideoModel>> watchVideos() {
    return firestore
        .collection('videos')
        .orderBy('order')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => VideoModel.fromJson(doc.data(), doc.id))
              .toList(),
        );
  }
}
