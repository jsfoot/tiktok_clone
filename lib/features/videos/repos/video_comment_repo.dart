import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/videos/models/video_comment_model.dart';

class VideoCommentRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createVideoComment(VideoCommentModel comment, String videoId) async {
    await _db.collection("videos").doc(videoId).collection("comments").add(comment.toJson());

    final query = await _db.collection("videos").doc(videoId).get();
    final data = query.data();
    final commentsCount = data!['comments'];
    await _db.collection("videos").doc(videoId).update({
      "comments": commentsCount + 1,
    });
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getVideoComment(String videoId) async {
    final query = await _db
        .collection("videos")
        .doc(videoId)
        .collection("comments")
        .orderBy("createdAt")
        .get();
    return query.docs;
  }
}

final videoCommentRepo = Provider((ref) => VideoCommentRepository());
