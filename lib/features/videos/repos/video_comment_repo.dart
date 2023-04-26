import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/videos/models/video_comment_model.dart';

class VideoCommentRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createVideoComment(VideoCommentModel comment, String videoId) async {
    await _db.collection("videos").doc(videoId).collection("comments").add(comment.toJson());
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getVideoComment(String videoId) async {
    final query = await _db.collection("videos").doc(videoId).collection("comments").get();
    return query.docs;
  }
}

final videoCommentRepo = Provider((ref) => VideoCommentRepository());
