import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/videos/models/video_comment_model.dart';

class VideoCommentRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createVideoComment(
      {required VideoCommentModel commentModel,
      required String videoId,
      required String commentId}) async {
    await _db
        .collection("videos")
        .doc(videoId)
        .collection("comments")
        .doc(commentId)
        .set(commentModel.toJson());

    await _db.collection("videos").doc(videoId).update({
      "comments": FieldValue.increment(1),
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

  Future<DocumentSnapshot<Map<String, dynamic>>> getVideoSingleComment(
      {required String videoId, required String commentId}) async {
    return await _db.collection("videos").doc(videoId).collection("comments").doc(commentId).get();
  }

  Future<void> increaseLike(
      {required String commentId, required String videoId, required String userId}) async {
    await _db.collection("videos").doc(videoId).collection("comments").doc(commentId).update({
      "likes": FieldValue.increment(1),
      "likedUsers": FieldValue.arrayUnion([userId]),
    });
  }

  Future<void> decreaseLike(
      {required String commentId, required String videoId, required String userId}) async {
    await _db.collection("videos").doc(videoId).collection("comments").doc(commentId).update({
      "likes": FieldValue.increment(-1),
      "likedUsers": FieldValue.arrayRemove([userId]),
    });
  }
}

final videoCommentRepo = Provider((ref) => VideoCommentRepository());
